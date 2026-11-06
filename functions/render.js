// 검색엔진·AI가 읽을 수 있는 서버 HTML, 뉴스 사이트맵, RSS를 만드는 순수 함수 모음.
// Firestore에 의존하지 않으므로 index.js에서 데이터만 넘겨 사용하고, 단독으로 테스트할 수 있다.

const BASE_URL = "https://tnmfact.com";
const SITE_NAME = "TNM팩트";
const OG_IMAGE = `${BASE_URL}/og-image-v2.png`;
const LOGO = `${BASE_URL}/icons/Icon-512.png`;

// 화면(Flutter)의 CategoryHelper.getCategoryName과 같은 규칙.
const BYLINES = {
    "이슈 팩트": { name: "김병국 기자", type: "Person" },
    "포커스 팩트": { name: "에디터 힙더바리", type: "Person" },
    "인사이트 팩트": { name: "TNM팩트 편집부", type: "Organization" },
    "피플&뷰": { name: "편집장 김병국", type: "Person" },
};

function bylineFor(category) {
    return BYLINES[category] ?? { name: "김병국", type: "Person" };
}

function escapeHtml(value = "") {
    return String(value)
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");
}

// XML 1.0에서 허용되지 않는 제어문자를 제거한 뒤 이스케이프한다.
function escapeXml(value = "") {
    return escapeHtml(
        String(value).replace(/[\u0000-\u0008\u000B\u000C\u000E-\u001F]/g, ""),
    );
}

function postUrl(title) {
    return `${BASE_URL}/post/${encodeURIComponent(title)}`;
}

function toDate(value) {
    if (!value) return null;
    if (typeof value.toDate === "function") return value.toDate();
    if (value instanceof Date) return value;
    const parsed = new Date(value);
    return Number.isNaN(parsed.getTime()) ? null : parsed;
}

// 2026-10-29T18:00:00+09:00 형식(한국 시간).
function toKstIso(date) {
    const kst = new Date(date.getTime() + 9 * 60 * 60 * 1000);
    return kst.toISOString().replace(/\.\d{3}Z$/, "+09:00");
}

// 화면 표기와 같은 26.10.29 형식.
function toKstShort(date) {
    const kst = new Date(date.getTime() + 9 * 60 * 60 * 1000);
    const yy = String(kst.getUTCFullYear()).slice(2);
    const mm = String(kst.getUTCMonth() + 1).padStart(2, "0");
    const dd = String(kst.getUTCDate()).padStart(2, "0");
    return `${yy}.${mm}.${dd}`;
}

function articleText(post) {
    return (post.final_article ?? post.content ?? "").toString();
}

function plainSummary(text, max = 160) {
    const clean = text.replace(/\s+/g, " ").trim();
    return clean.length > max ? `${clean.substring(0, max)}...` : clean;
}

// 빈 줄을 문단 경계로, 문단 안 줄바꿈은 <br>로 바꾼다.
function articleParagraphs(text) {
    return text
        .replace(/\r\n?/g, "\n")
        .split(/\n\s*\n/)
        .map((block) => block.trim())
        .filter(Boolean)
        .map((block) =>
            `<p>${block.split("\n").map((line) => escapeHtml(line.trim())).join("<br>")}</p>`,
        )
        .join("\n      ");
}

// <script> 안에 넣어도 안전한 JSON.
function safeJson(value) {
    return JSON.stringify(value)
        .replace(/</g, "\\u003c")
        .replace(/>/g, "\\u003e")
        .replace(/&/g, "\\u0026");
}

function newsArticleJsonLd(post) {
    const title = (post.title ?? "").toString();
    const url = postUrl(title);
    const date = toDate(post.date);
    const byline = bylineFor(post.category);
    const published = date ? toKstIso(date) : undefined;

    return {
        "@context": "https://schema.org",
        "@type": "NewsArticle",
        headline: title,
        description: plainSummary(articleText(post)),
        image: [OG_IMAGE],
        datePublished: published,
        dateModified: published,
        articleSection: post.category || undefined,
        inLanguage: "ko",
        author: [{ "@type": byline.type, name: byline.name, url: BASE_URL }],
        publisher: {
            "@type": "Organization",
            name: SITE_NAME,
            url: BASE_URL,
            logo: { "@type": "ImageObject", url: LOGO },
        },
        mainEntityOfPage: { "@type": "WebPage", "@id": url },
    };
}

function renderPostHtml(post) {
    const title = (post.title ?? "").toString();
    const text = articleText(post);
    const url = postUrl(title);
    const date = toDate(post.date);
    const byline = bylineFor(post.category);

    const safeTitle = escapeHtml(title);
    const safeDescription = escapeHtml(plainSummary(text));
    const category = escapeHtml(post.category ?? "");
    const published = date ? toKstIso(date) : "";

    return `<!DOCTYPE html>
<html lang="ko">
<head>
  <base href="/">
  <meta charset="UTF-8">
  <meta content="IE=Edge" http-equiv="X-UA-Compatible">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="naver-site-verification" content="ac18c61fc5b4431fa0bb0a5d325ffc850fd046" />

  <title>${safeTitle} | ${SITE_NAME}</title>
  <meta name="description" content="${safeDescription}" />
  <meta name="author" content="${escapeHtml(byline.name)}" />
  <link rel="canonical" href="${url}" />
  <link rel="alternate" type="application/rss+xml" title="${SITE_NAME}" href="${BASE_URL}/rss.xml" />

  <meta property="og:type" content="article" />
  <meta property="og:site_name" content="${SITE_NAME}" />
  <meta property="og:title" content="${safeTitle} | ${SITE_NAME}" />
  <meta property="og:description" content="${safeDescription}" />
  <meta property="og:url" content="${url}" />
  <meta property="og:image" content="${OG_IMAGE}" />
  <meta property="og:locale" content="ko_KR" />
  ${published ? `<meta property="article:published_time" content="${published}" />` : ""}
  ${category ? `<meta property="article:section" content="${category}" />` : ""}
  <meta name="twitter:card" content="summary_large_image" />

  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-status-bar-style" content="black">
  <meta name="apple-mobile-web-app-title" content="TNM팩트">
  <link rel="apple-touch-icon" href="/icons/Icon-192.png">
  <link rel="icon" type="image/png" href="/favicon-v2.png">
  <link rel="manifest" href="/manifest.json">

  <script type="application/ld+json">${safeJson(newsArticleJsonLd(post))}</script>

  <style>
    /* Flutter가 뜨기 전, 또는 스크립트를 실행하지 않는 검색엔진·AI가 보는 기사 본문 */
    #tnm-article { max-width: 680px; margin: 0 auto; padding: 32px 20px 64px;
      font-family: 'Pretendard', -apple-system, 'Apple SD Gothic Neo', sans-serif;
      color: #111; line-height: 1.75; font-size: 17px; }
    #tnm-article .site { font-weight: 700; color: #4b3fd8; text-decoration: none; }
    #tnm-article .section { display: inline-block; margin-top: 24px; font-size: 13px; color: #555; }
    #tnm-article h1 { font-size: 28px; line-height: 1.35; margin: 8px 0 12px; }
    #tnm-article .byline { font-size: 13px; color: #666; margin-bottom: 24px; }
    #tnm-article p { margin: 0 0 1.2em; }
    flutter-view { z-index: 1; }
  </style>

  <script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-3888199603950590" crossorigin="anonymous"></script>
</head>

<body>
  <article id="tnm-article">
    <a class="site" href="${BASE_URL}/">TNM팩트</a>
    <header>
      ${category ? `<span class="section">${category}</span>` : ""}
      <h1>${safeTitle}</h1>
      <p class="byline">작성자: <span>${escapeHtml(byline.name)}</span>${date ? ` | <time datetime="${published}">${toKstShort(date)}</time>` : ""}</p>
    </header>
    <div class="body">
      ${articleParagraphs(text)}
    </div>
  </article>
  <script src="/flutter_bootstrap.js" async></script>
</body>
</html>`;
}

// 구글 뉴스 사이트맵: 최근 2일 안에 처음 게시된 기사만, 최대 1,000개.
function renderNewsSitemap(posts, now = new Date()) {
    const cutoff = now.getTime() - 2 * 24 * 60 * 60 * 1000;
    const entries = posts
        .map((post) => ({ post, date: toDate(post.date) }))
        .filter(({ post, date }) => (post.title ?? "").toString().trim() && date && date.getTime() >= cutoff)
        .slice(0, 1000)
        .map(({ post, date }) => `  <url>
    <loc>${escapeXml(postUrl(post.title.toString().trim()))}</loc>
    <news:news>
      <news:publication>
        <news:name>${SITE_NAME}</news:name>
        <news:language>ko</news:language>
      </news:publication>
      <news:publication_date>${toKstIso(date)}</news:publication_date>
      <news:title>${escapeXml(post.title.toString().trim())}</news:title>
    </news:news>
  </url>`);

    return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"
        xmlns:news="http://www.google.com/schemas/sitemap-news/0.9">
${entries.join("\n")}
</urlset>`;
}

// 일반 사이트맵: 기존과 같지만 lastmod를 시각까지 표기.
function renderSitemap(posts) {
    const entries = posts
        .filter((post) => (post.title ?? "").toString().trim())
        .map((post) => {
            const date = toDate(post.date);
            return `  <url>
    <loc>${escapeXml(postUrl(post.title.toString().trim()))}</loc>
    ${date ? `<lastmod>${toKstIso(date)}</lastmod>` : ""}
  </url>`;
        });

    return `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>${BASE_URL}/</loc>
  </url>
${entries.join("\n")}
</urlset>`;
}

// RSS 2.0: 최근 기사 50개, 본문 전체 포함.
function renderRss(posts, now = new Date()) {
    const items = posts
        .filter((post) => (post.title ?? "").toString().trim())
        .slice(0, 50)
        .map((post) => {
            const title = post.title.toString().trim();
            const url = postUrl(title);
            const date = toDate(post.date);
            const text = articleText(post);
            return `    <item>
      <title>${escapeXml(title)}</title>
      <link>${escapeXml(url)}</link>
      <guid isPermaLink="true">${escapeXml(url)}</guid>
      ${post.category ? `<category>${escapeXml(post.category)}</category>` : ""}
      <dc:creator>${escapeXml(bylineFor(post.category).name)}</dc:creator>
      ${date ? `<pubDate>${date.toUTCString()}</pubDate>` : ""}
      <description>${escapeXml(plainSummary(text, 300))}</description>
      <content:encoded>${escapeXml(articleParagraphs(text))}</content:encoded>
    </item>`;
        });

    return `<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0"
     xmlns:content="http://purl.org/rss/1.0/modules/content/"
     xmlns:dc="http://purl.org/dc/elements/1.1/"
     xmlns:atom="http://www.w3.org/2005/Atom">
  <channel>
    <title>${SITE_NAME}</title>
    <link>${BASE_URL}/</link>
    <atom:link href="${BASE_URL}/rss.xml" rel="self" type="application/rss+xml" />
    <description>세상을 정확하고 이해하기 쉽게 설명하는 텍스트 중심 매체</description>
    <language>ko</language>
    <lastBuildDate>${now.toUTCString()}</lastBuildDate>
${items.join("\n")}
  </channel>
</rss>`;
}

module.exports = {
    bylineFor,
    escapeHtml,
    newsArticleJsonLd,
    renderPostHtml,
    renderNewsSitemap,
    renderSitemap,
    renderRss,
};
