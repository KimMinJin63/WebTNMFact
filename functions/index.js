const { setGlobalOptions } = require("firebase-functions");
const { onRequest } = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

setGlobalOptions({ maxInstances: 10 });

initializeApp();

const db = getFirestore();

exports.sitemap = onRequest(
    {
        region: "asia-northeast3",
    },
    async (request, response) => {
        try {
            const snapshot = await db
                .collection("post")
                .where("status", "==", "발행")
                .orderBy("date", "desc")
                .get();

            const baseUrl = "https://tnmfact.com";

            const urls = snapshot.docs.map((doc) => {
                const data = doc.data();

                const title = (data.title ?? "").toString().trim();
                const date = data.date;

                if (!title) {
                    return null;
                }

                const encodedTitle = encodeURIComponent(title);

                let lastmod = "";

                if (date && typeof date.toDate === "function") {
                    lastmod = date.toDate().toISOString().split("T")[0];
                }

                return `
  <url>
    <loc>${baseUrl}/post/${encodedTitle}</loc>
    ${lastmod ? `<lastmod>${lastmod}</lastmod>` : ""}
  </url>`;
            }).filter(Boolean);

            const xml = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>${baseUrl}/</loc>
  </url>
${urls.join("\n")}
</urlset>`;

            response.set("Content-Type", "application/xml");
            response.status(200).send(xml);
        } catch (error) {
            logger.error("sitemap 생성 실패", error);
            response.status(500).send("Failed to generate sitemap");
        }
    }
);
function escapeHtml(value = "") {
    return value
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");
}

exports.postPage = onRequest(
    {
        region: "asia-northeast3",
    },
    async (request, response) => {
        try {
            const encodedTitle = request.path.replace(/^\/post\//, "");
            const title = decodeURIComponent(encodedTitle);

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
            const postTitle = (post.title ?? "").toString();
            const article =
                (post.final_article ?? post.content ?? "").toString();

            const cleanText = article
                .replace(/\s+/g, " ")
                .trim();

            const description = cleanText.length > 160
                ? `${cleanText.substring(0, 160)}...`
                : cleanText;

            const canonicalUrl =
                `https://tnmfact.com/post/${encodeURIComponent(postTitle)}`;

            const safeTitle = escapeHtml(postTitle);
            const safeDescription = escapeHtml(description);

            const html = `<!DOCTYPE html>
<html lang="ko">
<head>
  <base href="/">

  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">

  <meta
    name="naver-site-verification"
    content="ac18c61fc5b4431fa0bb0a5d325ffc850fd046"
  />

  <title>${safeTitle} | TNM팩트</title>

  <meta
    name="description"
    content="${safeDescription}"
  />

  <link
    rel="canonical"
    href="${canonicalUrl}"
  />

  <meta property="og:type" content="article" />
  <meta property="og:title" content="${safeTitle} | TNM팩트" />
  <meta property="og:description" content="${safeDescription}" />
  <meta property="og:url" content="${canonicalUrl}" />
  <meta property="og:image" content="https://tnmfact.com/og-image-v2.png" />

  <meta name="twitter:card" content="summary_large_image" />

  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="TNM FACT">

  <link rel="apple-touch-icon" href="/icons/Icon-192.png">
  <link rel="icon" type="image/png" href="/favicon-v2.png">
  <link rel="manifest" href="/manifest.json">

  <script
    async
    src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-3888199603950590"
    crossorigin="anonymous">
  </script>
</head>

<body>
  <script src="/flutter_bootstrap.js" async></script>
</body>
</html>`;

            response.set("Content-Type", "text/html; charset=utf-8");
            response.set(
                "Cache-Control",
                "public, max-age=300, s-maxage=300",
            );

            response.status(200).send(html);
        } catch (error) {
            logger.error("게시글 HTML 생성 실패", error);
            response.status(500).send("Failed to generate post page");
        }
    }
);