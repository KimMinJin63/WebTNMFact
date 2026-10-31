const { setGlobalOptions } = require("firebase-functions");
const { onRequest } = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

const {
    renderPostHtml,
    renderNewsSitemap,
    renderSitemap,
    renderRss,
} = require("./render");

setGlobalOptions({ maxInstances: 10 });

initializeApp();

const db = getFirestore();

const REGION = "asia-northeast3";

// 발행된 글을 최신순으로 가져온다. (기존 sitemap과 같은 쿼리·색인 사용)
async function publishedPosts(limit) {
    let query = db
        .collection("post")
        .where("status", "==", "발행")
        .orderBy("date", "desc");
    if (limit) query = query.limit(limit);
    const snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data());
}

exports.sitemap = onRequest({ region: REGION }, async (request, response) => {
    try {
        const posts = await publishedPosts();
        response.set("Content-Type", "application/xml; charset=utf-8");
        response.set("Cache-Control", "public, max-age=600, s-maxage=600");
        response.status(200).send(renderSitemap(posts));
    } catch (error) {
        logger.error("sitemap 생성 실패", error);
        response.status(500).send("Failed to generate sitemap");
    }
});

// 구글 뉴스 사이트맵: 최근 2일 기사만. 새 기사가 빨리 반영되도록 캐시를 짧게 둔다.
exports.newsSitemap = onRequest({ region: REGION }, async (request, response) => {
    try {
        const posts = await publishedPosts(1000);
        response.set("Content-Type", "application/xml; charset=utf-8");
        response.set("Cache-Control", "public, max-age=300, s-maxage=300");
        response.status(200).send(renderNewsSitemap(posts));
    } catch (error) {
        logger.error("뉴스 사이트맵 생성 실패", error);
        response.status(500).send("Failed to generate news sitemap");
    }
});

exports.rss = onRequest({ region: REGION }, async (request, response) => {
    try {
        const posts = await publishedPosts(50);
        response.set("Content-Type", "application/rss+xml; charset=utf-8");
        response.set("Cache-Control", "public, max-age=300, s-maxage=300");
        response.status(200).send(renderRss(posts));
    } catch (error) {
        logger.error("RSS 생성 실패", error);
        response.status(500).send("Failed to generate RSS");
    }
});

exports.postPage = onRequest({ region: REGION }, async (request, response) => {
    try {
        const encodedTitle = request.path.replace(/^\/post\//, "");
        let title = "";
        try {
            title = decodeURIComponent(encodedTitle);
        } catch (_) {
            title = encodedTitle;
        }

        if (!title) {
            response.status(404).send("Post not found");
            return;
        }

        const snapshot = await db
            .collection("post")
            .where("title", "==", title)
            .limit(1)
            .get();

        if (snapshot.empty) {
            response.status(404).send("Post not found");
            return;
        }

        const post = snapshot.docs[0].data();

        if (post.status !== "발행") {
            response.status(404).send("Post not found");
            return;
        }

        response.set("Content-Type", "text/html; charset=utf-8");
        response.set("Cache-Control", "public, max-age=300, s-maxage=300");
        response.status(200).send(renderPostHtml(post));
    } catch (error) {
        logger.error("게시글 HTML 생성 실패", error);
        response.status(500).send("Failed to generate post page");
    }
});
