class Post {
  final int id;
  final String image;
  final String title;
  final String description;
  final String text;
  final String author;
  final String date;

  const Post._({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.text,
    required this.author,
    required this.date,
  });

  factory Post(int id) => all[id];

  static int get count => all.length;

  static const all = <Post>[
    Post._(
      id: 0,
      image: '/images/post-0.webp',
      title:
          "Why Flutter Web Pages Get Stuck in 'Discovered – Currently Not Indexed'",
      description:
          'Decoding the most common Google Search Console status that haunts Flutter web apps, and what crawl-budget signals to fix first.',
      text:
          '"Discovered – currently not indexed" is the status Google Search Console returns when it has learned that a URL exists, usually through a sitemap or an internal link, but has not yet downloaded the page itself. Many Flutter web developers see this message for the bulk of their detail-page URLs and assume something is technically broken. Usually nothing is broken in the server response. The issue lies in Google\'s perception of the URL\'s value. '
          'Google distributes crawl capacity across the open web according to perceived priority. A new domain, especially one on a shared subdomain such as netlify.app or vercel.app, starts with a small crawl budget. Detail pages on Flutter SPAs make this worse for two reasons. First, every route returns the same shell HTML before JavaScript executes, so the first-pass crawler cannot tell whether the URL contains anything different from the homepage. Second, when Google does render the page later, identical structure plus minor text variation reads as templated content, which lowers domain trust. '
          'To climb out of the queue, three signals matter most. Internal links: a URL with at least one inbound link from a high-priority page is dramatically more likely to be crawled than a sitemap-only entry. Distinct rendered content: each URL should produce a unique title, a unique meta description, and at least a few hundred words of text that does not repeat verbatim across pages. Authority signals: any inbound link from a higher-authority domain, a personal site, a public repo\'s README, or a community post, shifts the page from "discovered" to "crawled" in days. '
          'The seo package handles the rendered-HTML side, but it cannot manufacture authority. If most of a Flutter site\'s URLs are stuck in "Discovered," the next move is content quality and link building, not deeper technical fixes.',
      author: 'Skia Crawley',
      date: 'June 22, 2026',
    ),
    Post._(
      id: 1,
      image: '/images/post-1.webp',
      title: 'How CanvasKit Renders Without Producing HTML for Crawlers',
      description:
          "Why Flutter's CanvasKit renderer is invisible to text-based crawlers, and how the seo package fills the gap.",
      text:
          'CanvasKit is the default renderer for Flutter web builds. It compiles Skia, the same graphics library Flutter uses on mobile, into WebAssembly and paints every Flutter widget onto a single HTML canvas element. The result is a visually faithful rendering across browsers, but it is also an SEO disaster if you do not plan for it. '
          'A canvas element is opaque to the DOM. The text inside it is composed of pixels, not characters. There are no heading, paragraph, or anchor tags for a crawler to read. To a search engine, a CanvasKit page looks like a body with a single empty canvas element. No headings, no body text, no internal links, no images that crawlers can interpret. Lighthouse reports might still award a high score because the headers and meta tags in index.html look correct, but actual search engines have nothing to index beyond what is in head. '
          'The seo package solves this by maintaining a parallel DOM tree alongside the canvas. When a widget wrapped in Seo.text, Seo.image, Seo.link, or Seo.head enters the widget tree, the package controller injects an equivalent HTML node into the document body. The result is two surfaces drawn over each other: the visible canvas for humans and the hidden HTML for crawlers. '
          'This approach does not replace server-side rendering, but it does cover the most common needs: per-route titles, descriptions, headings, paragraphs, and links. The injected nodes carry an flt-seo attribute, making them easy to inspect in DevTools, and they update reactively when navigation changes the widget tree. '
          'Two caveats remain. Google\'s web rendering service must successfully execute the page\'s JavaScript to see the injected HTML, so very slow first paints can still cause indexing problems. And dynamic injection happens after page load, which means social-media crawlers that do not execute JavaScript will not see meta tags. For Open Graph support, a server-side render of index.html is still required.',
      author: 'Skia Crawley',
      date: 'June 18, 2026',
    ),
    Post._(
      id: 2,
      image: '/images/post-2.webp',
      title:
          'Setting Per-Route Titles in Flutter Web Without Server-Side Rendering',
      description:
          'How SystemChrome.setApplicationSwitcherDescription doubles as a per-page title setter in Flutter web, and why that matters for SEO.',
      text:
          "Flutter's web embedder is built around a canvas element, so most widgets never touch the surrounding HTML. The document title tag, however, is global to the document, and Flutter does expose a hook for updating it: SystemChrome.setApplicationSwitcherDescription. On native platforms, this method sets the label shown in the OS task switcher. On the web, the Flutter engine implements it as a document.title update. "
          'This dual behavior is convenient because the same code path handles both native and web. Triggered from a VisibilityDetector, a single call updates document.title whenever the route becomes visible. Combined with the seo package MetaTag for name title, the browser tab title, the OS-level label, and the HTML title tag all stay in sync. '
          "The technique has two benefits for SEO. First, Google's web rendering service reads the final document.title after JavaScript executes, so per-route titles produced this way are picked up correctly. Second, because the title updates without a full page reload, single-page navigation in Flutter feels native, with browser history showing meaningful entries instead of a default label repeated for every URL. "
          'There are caveats. The update fires only when the widget enters the visible region, so off-screen pre-rendered routes need an explicit trigger. The Flutter engine flushes title updates synchronously, but if a route mounts and unmounts quickly during a redirect, the title may briefly flash to the previous value. And browsers do not allow scripts to set the title until the document has loaded, so very early initialization needs to wait for the engine to be ready. '
          'For most Flutter web apps, this single line of code is the difference between every URL showing the same fallback title and each route announcing its actual content to search engines and bookmarks alike.',
      author: 'Skia Crawley',
      date: 'June 14, 2026',
    ),
    Post._(
      id: 3,
      image: '/images/post-3.webp',
      title: 'Canonical URLs in Single-Page Apps: A Practical Guide',
      description:
          'Why every Flutter SPA route should declare its own canonical URL, and how missing canonicals cause Google to consolidate pages.',
      text:
          'A canonical URL tells search engines which version of a page should be treated as authoritative when multiple URLs serve similar content. In static websites, canonical declarations are usually copied wholesale from the URL itself. In single-page apps, the situation is murkier because every route shares the same index.html, and any per-route signaling has to come from JavaScript. '
          'When a canonical declaration is missing, Google falls back to its own heuristics. For a Flutter SPA, that often means consolidating all detail-page URLs onto the homepage canonical because the homepage is the only URL with strong signals attached. The detail pages then appear in Search Console with the status "Duplicate, Google chose different canonical than user." They will not rank for their own content. '
          'The fix is to emit a canonical link tag per route. With the seo package, the pattern is straightforward: wrap the page in Seo.head with a LinkTag whose rel is canonical and whose href is the absolute URL for the current route. '
          'A few rules apply. The canonical URL must be absolute, including the scheme. It should match the URL exactly, including trailing slashes and case. It should self-reference the current page in almost all cases. Pointing a detail page to the homepage as canonical effectively tells Google not to index the detail page at all. '
          'In Flutter web, Uri.base returns the current location, but for canonical generation it is safer to construct the URL from the route\'s known shape rather than the live URL. This avoids accidental inclusion of query parameters, fragment identifiers, or trailing slashes added by the router. '
          'One last detail: the canonical tag must be present when Google\'s renderer finishes executing JavaScript. The seo package handles this by injecting the tag into head shortly after the controller mounts. Confirm with Search Console URL Inspection live test that the canonical appears in the rendered HTML view. That is the ground truth.',
      author: 'Skia Crawley',
      date: 'June 9, 2026',
    ),
    Post._(
      id: 4,
      image: '/images/post-4.webp',
      title: 'Why noscript img Is Invisible to JavaScript-Enabled Crawlers',
      description:
          'A common SEO mistake in JavaScript-rendered apps: wrapping fallback images in noscript actually hides them from Googlebot.',
      text:
          'Web developers reach for noscript instinctively when designing fallbacks for JavaScript-rendered content. The intuition is sensible: if a browser cannot execute scripts, the fallback should show something useful, and a wrapped image tag will display only when the script-free path is taken. For images that the page would otherwise paint into a canvas, this seems like a clean way to give crawlers an image to find. '
          'The trouble is that modern crawlers, including Googlebot, execute JavaScript. They render the page in a real browser engine, and that engine specifically skips the contents of noscript when scripts are enabled. The fallback image is parsed, but the browser intentionally does not load it, render it, or expose it through the visual or accessibility layers that a crawler reads. '
          'The net effect is that wrapping a fallback image in noscript makes it invisible to almost everyone. JavaScript-enabled humans never see it. Crawlers do not load it. Only legacy browsers and a small fraction of users with scripts disabled benefit, and they are not the audience that matters for indexing. '
          'For image SEO in a Flutter web app, the choice is binary. Either expose the image as a real image tag in the DOM, accepting that the browser will download it once for the canvas render and once for the DOM, or accept that image search will never index the content. '
          'Mitigating the double-fetch is possible. The lazy loading attribute defers image downloads until they scroll into view; low fetch priority deprioritizes them in the network queue. For images positioned outside the visible viewport, exactly where a hidden SEO layer lives, these attributes prevent the browser from fetching the image until something forces it to. Crawlers, on the other hand, still parse the URL and consider it a candidate for image search. '
          'The cleanest approach is to make the call explicit. If image indexing matters, drop the noscript wrapper and add lazy-loading attributes. If it does not, leave the wrapper in place but recognize that the fallback is decorative, not functional.',
      author: 'Skia Crawley',
      date: 'June 3, 2026',
    ),
    Post._(
      id: 5,
      image: '/images/post-5.webp',
      title: 'Sitemap.xml Best Practices for Lazy-Loaded Flutter Lists',
      description:
          'A static sitemap.xml is essential for Flutter list pages that only render visible items, since orphan URLs never appear as internal links.',
      text:
          "Flutter's ListView.builder and ListView.separated are lazy: only the items currently in the viewport, plus a small cache window, are materialized. Off-screen list items are not in the widget tree, which means the seo package does not see them, which in turn means no anchor tags get injected for those URLs. For a long list, the result is that the homepage links to only the first handful of detail pages, and every other URL is effectively orphaned. "
          'Orphan URLs are not impossible to crawl, but they have a meaningfully lower priority. Google relies on internal links to estimate which pages are important relative to others, and a URL with zero inbound links carries no signal at all. A well-formed sitemap.xml is the way to compensate. '
          'Three rules cover most cases. First, list every canonical URL exactly once. Avoid trailing slashes or alternate URL forms; they confuse the priority signal. Second, keep lastmod accurate. A stale lastmod value, especially one identical across all entries, tells Google not to prioritize a re-crawl. Third, reference the sitemap from robots.txt. The Sitemap directive is what makes Google discover the sitemap without manual submission. '
          'For Flutter web apps, the sitemap is usually generated as part of the build pipeline. A typical setup keeps a template sitemap.xml in web with a placeholder for the base URL, then a CI step rewrites the placeholder to the production domain before the Netlify or Firebase deploy. '
          'When the list is finite and known at build time, the cleanest approach is to enumerate every URL explicitly. When it is dynamic, say posts pulled from a database, the build step should query the source of truth at deploy time and write the URLs in a deterministic order so that diffs are reviewable. '
          'One last note: even with a complete sitemap, a URL that ranks well still benefits from at least one inbound internal link. The sitemap gets the URL discovered; internal links get it valued.',
      author: 'Skia Crawley',
      date: 'May 28, 2026',
    ),
    Post._(
      id: 6,
      image: '/images/post-6.webp',
      title:
          'Using the seo Package to Inject Crawlable HTML in Flutter Web',
      description:
          'An overview of the seo package widgets and how to integrate them into an existing Flutter web app without restructuring it.',
      text:
          'The seo package is designed to be added incrementally to an existing Flutter web codebase. Rather than requiring a separate render tree or build-time HTML generation, it watches the widget tree for opt-in markers and produces matching HTML nodes alongside the canvas. The integration surface is small: wrap the app with SeoController, then sprinkle Seo widgets at the points where crawlable content lives. '
          'SeoController is the orchestrator. It takes a SeoTree, most commonly a WidgetTree, and listens for changes. On each tree change, the controller waits for the current frame to finish, walks the tree to collect markers, generates HTML, and writes it into the DOM. The debounce avoids thrashing on rapid state changes. '
          'The four primary marker widgets cover most needs. Seo.text emits a heading or paragraph element based on TextTagStyle, while continuing to render the wrapped child as a Flutter widget. Seo.image emits an image tag with the supplied URL and alt text; by default the tag is wrapped in noscript to avoid double-loading, though this also hides it from JS-enabled crawlers. Seo.link emits an anchor tag pointing at the given URL, with the anchor text inside; internal links should match the route path so that crawlers can follow them. Seo.head injects meta and link tags into the document head; use it once per route, typically inside a wrapper widget such as an AppHead. '
          'A common pattern is to define thin wrappers around the Seo widgets that pair them with their visual counterparts. An AppText wraps a Text plus a Seo.text, an AppImage wraps an Image.network plus a Seo.image, and so on. This keeps the SEO concern out of feature code while ensuring no widget ships without its semantic equivalent. '
          'The injected nodes are marked with an flt-seo attribute, so they are easy to inspect in DevTools and easy to remove in tests.',
      author: 'Skia Crawley',
      date: 'May 21, 2026',
    ),
    Post._(
      id: 7,
      image: '/images/post-7.webp',
      title:
          'Open Graph Meta Tags and the Server-Side Rendering Requirement',
      description:
          'Why Open Graph and Twitter Card previews do not work in client-side Flutter apps, and what to do about it.',
      text:
          'Open Graph is the metadata protocol that Facebook, Twitter, LinkedIn, Slack, Discord, and most other social platforms use to render rich previews when a link is shared. The protocol expects a small set of meta tags in the HTML head, such as og:title, og:description, og:image, and og:url, to be present when the URL is fetched. '
          'The catch is that social-media crawlers do not execute JavaScript. They issue a single HTTP request, parse the response body as HTML, look for the tags, and assemble the preview. There is no two-wave indexing in this world, no headless Chrome rendering. If the response body does not contain the meta tags, no preview is generated. '
          'For Flutter web apps, this is a hard constraint. The seo package can inject Open Graph tags into the DOM after the app boots, and Google\'s renderer will see them, but social-media crawlers will see only the static index.html. Whatever Open Graph tags need to surface to those crawlers must be in the initial HTML response. '
          'There are three practical solutions. Static fallback tags: if the same preview is acceptable for every URL, for example a global brand image and tagline, the tags can live directly in index.html. This is the simplest path and works for marketing sites where individual routes are not shared independently. Server-side rewriting: a small edge function running on Netlify Edge, Cloudflare Workers, or Vercel Edge can intercept the response, look up route-specific data, and inject the appropriate Open Graph tags before returning the HTML. This preserves the Flutter app while enabling per-URL previews. Pre-rendering: a build-step process renders each route through a headless browser, captures the resulting HTML, and serves the static file for that URL. Pre-rendered HTML naturally includes the Open Graph tags that the Flutter app injected at render time. '
          'The first option is enough for many demos. The second is the production-grade default. Either way, the constraint is fixed: Open Graph and JavaScript-rendered apps do not mix.',
      author: 'Skia Crawley',
      date: 'May 14, 2026',
    ),
    Post._(
      id: 8,
      image: '/images/post-8.webp',
      title: "Google's Two-Wave Indexing Explained for Flutter Developers",
      description:
          'How Google handles JavaScript-rendered pages in two phases, why the gap matters, and what it means for Flutter web SEO.',
      text:
          'When Googlebot encounters a URL, it does not run JavaScript on the first visit. The first wave is a fast text-only crawl: download the HTML, parse it as text, follow the discovered links, queue them for further crawling, and pass the URL into the rendering queue if the content looks dynamic. This is the wave that finds the URL but does not yet decide whether to index it. '
          'The second wave runs in the Web Rendering Service, a managed cluster of headless Chrome instances. It picks pages off the rendering queue, executes their JavaScript, takes a snapshot of the final DOM, and ships that snapshot back to the indexer. Indexing decisions, whether the URL appears in search results and for which queries, are made off the rendered snapshot, not the raw HTML. '
          'The two-wave architecture explains many quirks of Flutter web SEO. Detail-page URLs may appear in Search Console immediately as "Discovered" because the first wave found them in the sitemap, but their actual content may not show up for days or weeks because the rendering queue is backlogged. The render queue is prioritized by the same authority signals as the crawl queue, so low-trust domains wait longer. '
          'It also explains why a freshly deployed Flutter site can have several URLs in "Crawled — currently not indexed" status. The first wave finished, the renderer ran, but the snapshot looked too thin to be worth indexing. Google does not retry rendering immediately; it waits, sometimes weeks, before checking again. '
          'The implication for Flutter developers is that the snapshot returned by the renderer must contain everything the indexer needs. A title, a description, a unique main heading, and at least a few hundred words of distinct content. The Flutter app must finish rendering quickly enough that the headless Chrome instance does not time out, typically within five to ten seconds of network idle. '
          'When in doubt, Search Console URL Inspection tool exposes the actual rendered HTML the WRS produced. It is the only authoritative way to see what Google decided to index.',
      author: 'Skia Crawley',
      date: 'May 6, 2026',
    ),
    Post._(
      id: 9,
      image: '/images/post-9.webp',
      title: 'Pre-rendering Flutter Web: Static HTML Generation Strategies',
      description:
          'Three approaches to producing crawler-friendly static HTML for Flutter web routes, from build-step snapshots to edge rendering.',
      text:
          'Pre-rendering means generating a static HTML version of each route at build time, so crawlers and social-media bots receive a fully formed page without executing JavaScript. For Flutter web, pre-rendering is the most robust answer to indexing problems because it removes the dependency on Google\'s rendering queue entirely. '
          'Three strategies cover most needs. '
          'The first is a build-step snapshot. After flutter build web, a Node script launches a headless Chromium, navigates to each known URL using the local build, waits for the DOM to settle, and saves the resulting HTML alongside the Flutter assets. The Netlify or Firebase deploy then serves the per-URL HTML when its path is requested. This works well when the URL list is enumerable, for a blog or product catalog with a fixed number of items. The downside is build-time cost: each URL adds a few seconds, and the total can become unwieldy at hundreds of routes. '
          'The second is a serverless on-demand renderer. Rather than pre-render every URL upfront, the server renders a URL on first request, caches the result, and serves the cache for subsequent requests. Vercel Incremental Static Regeneration and Netlify On-Demand Builders both implement this pattern. The trade-off is that the first request after a deploy is slower, but the cache eliminates ongoing render cost. '
          'The third is edge rendering at request time. A Cloudflare Worker, Netlify Edge Function, or AWS Lambda@Edge intercepts the request, decides whether the requester is a crawler based on user agent, and either serves the static index.html for human users or renders the page through a small headless Chromium instance for bots. This avoids storing per-URL static files but introduces a runtime dependency on the renderer service. '
          'A fourth pattern, sometimes called dynamic rendering, has been deprecated by Google. It served different HTML to crawlers and humans, which can drift over time and risks looking like cloaking. '
          'For most Flutter web demos, the build-step snapshot is the cleanest entry point. For production sites, edge rendering or incremental regeneration scale better as the URL count grows.',
      author: 'Skia Crawley',
      date: 'April 28, 2026',
    ),
    Post._(
      id: 10,
      image: '/images/post-10.webp',
      title: 'How usePathUrlStrategy Affects Flutter Web Crawlability',
      description:
          'Path-based URLs versus hash-based URLs in Flutter web, and why the choice changes everything about how crawlers see your routes.',
      text:
          'By default, Flutter web uses hash-based routing. A URL with the route information encoded after a hash symbol is the standard form, with the route after a hash so the server only ever sees a request for the root path. This was a pragmatic choice in the early days of single-page apps: the hash portion is not sent to the server, so any static host could serve the same index.html for every route without configuration. '
          'For SEO, hash-based routing is a serious problem. Search engines treat the URL up to the hash as the canonical identifier and ignore everything after it. So a URL like /#/posts/0 and a URL like /#/posts/1 and the bare root URL all look like the same URL to a crawler. They will not be indexed as distinct pages. '
          'The function usePathUrlStrategy switches Flutter to true path-based URLs. Routes like /posts/0 appear in the address bar without a hash, and each unique path becomes a distinct URL from a search engine\'s perspective. The single line of code, called once before runApp, is the difference between zero indexable routes and full discoverability. '
          'The trade-off is that the static host must be configured to fall back to index.html for unknown paths. On Netlify, this is a one-line _redirects rule. On Firebase Hosting, it is a rewrite in firebase.json. Without the fallback, navigating directly to a detail page URL returns a 404 because the server has no file at that path. '
          'Three additional points worth knowing. The base href tag in index.html must be present for path-based routing to work correctly during local development. Browser back and forward navigation behaves identically to native multi-page sites, which improves the user experience as a side effect. Path-based URLs are required for any deployment of pre-rendering, since pre-rendered HTML is keyed by path. '
          'Hash-based routing is obsolete for any Flutter web app that wants to be found in search. The change is small; the impact is foundational.',
      author: 'Skia Crawley',
      date: 'April 19, 2026',
    ),
    Post._(
      id: 11,
      image: '/images/post-11.webp',
      title: "Why Indexed Pages Sometimes Drop Out of Google's Index",
      description:
          'Once-indexed URLs can disappear from search results over time. Three reasons this happens, and how to detect the cause.',
      text:
          'A URL that ranked well last quarter showing only the homepage today is one of the more frustrating SEO patterns to debug. Google does not announce deindexing decisions, and Search Console only reflects the final state, not the chain of events that led to it. There are three common causes, each with different diagnostics. '
          'The first is a domain-level quality re-evaluation. Google periodically re-scores domains based on accumulated signals: content quality, engagement metrics, link patterns, click behavior. A domain that ranks adequately at first may slip below an indexing threshold as the algorithm gathers more data. The signature is gradual: indexed URLs drop one by one over weeks, and new content takes longer and longer to appear. The remedy is to improve the underlying quality of the content and rebuild engagement. '
          'The second is a content change that broke the page. A redesign that removed key text, a JavaScript regression that prevents server-side or client-side rendering, a sudden increase in load time, any of these can cause Google to revisit and decide the URL is no longer worth surfacing. The signature is sudden: a cliff drop on a specific date, often correlated with a deploy. Search Console URL Inspection tool shows the rendered HTML the WRS captured most recently, which makes this case easy to diagnose. '
          'The third is a competitor or topic shift. A URL that ranked because the topic was uncontested may lose ranking when a higher-authority site publishes on the same topic. Google may keep the URL indexed but stop showing it in results, which from Search Console looks identical to deindexing. The signature is a sustained drop in impressions for specific queries while the URL itself remains in the index. The Performance report is the clearest signal here. '
          'When debugging, the order of operations is: Search Console Index Status to confirm what is indexed, URL Inspection to see what Google rendered, then the Performance report to see whether the URL still receives any impressions. The combination usually narrows the cause within an hour.',
      author: 'Skia Crawley',
      date: 'April 11, 2026',
    ),
    Post._(
      id: 12,
      image: '/images/post-12.webp',
      title: 'Testing What Googlebot Sees with the URL Inspection Tool',
      description:
          "A practical guide to using Search Console's URL Inspection tool to verify that Google's renderer sees your Flutter web content.",
      text:
          'Search Console URL Inspection tool is the single most useful debugging surface for Flutter web SEO. It exposes both the most recent indexed version of a URL and a live test that runs Google Web Rendering Service on demand. The live test is the ground truth: it shows exactly what Google would index if it crawled the URL right now. '
          'To open the tool, paste any URL from the property into the search bar at the top of Search Console. The first view shows the indexed status: whether the URL is in the index, when it was last crawled, and any errors or warnings. '
          'The more valuable button is "Test live URL." After a few seconds of rendering, the panel displays three sub-views. The Screenshot sub-view shows an image of how the page appeared to the WRS. For a Flutter web app, the screenshot may show a blank canvas if rendering timed out, or the full page if it completed in time. The HTML sub-view shows the rendered DOM, captured after JavaScript executed. This is where titles, meta descriptions, canonical links, and body text generated by the seo package should appear. The More Info sub-view lists console messages, blocked resources, and the response code. A JavaScript error here is often the smoking gun. '
          'For Flutter apps using the seo package, the HTML view should contain a div with the flt-seo attribute somewhere in the body with the page content. If it does not, the renderer ran out of time before the controller could inject. The fix is usually to reduce initial load: defer non-critical fonts, remove unused dependencies, or switch from CanvasKit to skwasm for faster boot. '
          'The live test also shows what the canonical URL resolved to. If a detail page reports the homepage as its canonical, that explains why the detail page is not indexed: Google rolled it up into the homepage. '
          'A note on caching: the live test result is not used to update the index. To re-index, request indexing from the same panel after confirming the live test looks correct.',
      author: 'Skia Crawley',
      date: 'April 2, 2026',
    ),
    Post._(
      id: 13,
      image: '/images/post-13.webp',
      title: 'Measuring Render Time for Flutter Web with Lighthouse',
      description:
          "Lighthouse audits surface the metrics that Google's rendering service cares about. Here is what to focus on for Flutter web.",
      text:
          "Lighthouse, the auditing tool built into Chrome DevTools and PageSpeed Insights, scores web pages across performance, accessibility, best practices, and SEO. For Flutter web apps, the SEO score is often misleadingly high because it checks for the presence of meta tags without evaluating whether the page actually renders in time for crawlers. The metrics that matter live in the performance section. "
          'The two most important figures are First Contentful Paint and Largest Contentful Paint. FCP measures when the first pixel appears, LCP when the largest meaningful element finishes painting. For Flutter web, FCP often clocks in at one to three seconds because the Flutter engine has to download, compile, and boot WASM or JavaScript before any pixel hits the canvas. LCP follows shortly after. '
          'Google rendering service waits for network idle to take its snapshot. A typical timeout is five seconds after the load event, with a hard ceiling around twenty seconds. If LCP exceeds the timeout, the renderer captures a partially rendered page and the snapshot will be missing content. The page may end up indexed with empty text. '
          'To improve render time, three optimizations move the needle. Choose the right renderer: skwasm boots faster than CanvasKit because the binary is smaller. For text-heavy sites, the visual difference is negligible but the SEO impact is substantial. Reduce the JavaScript payload: tree-shaking, code splitting, and removing unused dependencies all shrink the bytes the browser has to parse before the engine can boot. Prefetch the largest assets: adding a preload link for the main WASM file or main JavaScript bundle lets the browser start downloading them before the bootstrap script reaches the request. '
          'Total Blocking Time and Cumulative Layout Shift matter less for Flutter web because the canvas renders atomically; there is no incremental layout to shift. Focus on FCP, LCP, and Time to Interactive. If those are inside the renderer budget, the SEO score reflects something real.',
      author: 'Skia Crawley',
      date: 'March 24, 2026',
    ),
    Post._(
      id: 14,
      image: '/images/post-14.webp',
      title: 'Skwasm vs CanvasKit: Renderer Choice and SEO Implications',
      description:
          "Flutter web's two renderers ship different binaries and boot at different speeds. The choice affects whether crawlers see your content in time.",
      text:
          'Flutter web supports two rendering backends: CanvasKit, the longer-standing choice, and skwasm, the newer alternative. Both paint Flutter widgets onto a canvas element using Skia, but their compilation targets, binary sizes, and boot times differ in ways that matter for SEO. '
          'CanvasKit is a JavaScript wrapper around Skia compiled to WebAssembly. The runtime loads two files from Google CDN: a JavaScript shim that handles glue code and a WASM module containing the Skia engine. The total payload is around one and a half megabytes compressed. CanvasKit boots in two to four seconds on a modern machine and supports the broadest set of browsers, including older versions of Safari. '
          'Skwasm is a more direct route: Flutter widgets compiled directly to WebAssembly using dart2wasm, without the JavaScript layer. The resulting binary is smaller, around one megabyte, and boot times drop to one to two seconds. The trade-off is browser support: skwasm requires the WebAssembly Garbage Collection proposal, which limits it to recent Chromium, Firefox, and Safari versions. On unsupported browsers, the bootstrap automatically falls back to CanvasKit. '
          'For SEO, the boot-time difference is the most consequential. Google rendering service has a finite budget for each URL. A faster boot means the seo package controller has more time to walk the widget tree and inject HTML before the snapshot is taken. On low-priority domains, where the renderer may already be assigned a small budget, the seconds saved by skwasm can be the difference between an indexed page and a blank snapshot. '
          'The way to enable skwasm is to pass --wasm to flutter build web. The build then produces both targets, dart2wasm and dart2js, and ships both. The bootstrap detects the browser WASM-GC support at runtime and chooses the appropriate path. There is no extra configuration required for the dual-target deployment. '
          'The reverse migration is possible, but rarely advisable. CanvasKit wider compatibility comes at a measurable boot-time cost, and that cost lands directly on the SEO budget. For most modern sites, skwasm with a CanvasKit fallback is the right default.',
      author: 'Skia Crawley',
      date: 'March 15, 2026',
    ),
    Post._(
      id: 15,
      image: '/images/post-15.webp',
      title:
          'Building Internal Links for Better Flutter Web Crawl Coverage',
      description:
          'Google crawl prioritization relies on internal links. Here is how to structure a Flutter web app so every important URL gets discovered.',
      text:
          'Google does not crawl every URL it knows about with equal priority. Internal linking is one of the strongest signals it uses to decide which URLs to revisit, which to render fully, and which to leave at the bottom of the queue. A URL with three inbound links from prominent pages is dramatically more likely to be re-crawled and re-rendered than a URL that only appears in a sitemap. '
          'Flutter web apps tend to have weak internal linking for two reasons. First, ListView.builder and similar lazy widgets only mount visible items, so a list of one hundred detail pages may emit only the first five anchor tags. Second, navigation often happens through onTap callbacks rather than rendered anchors, which crawlers cannot follow. '
          'Three structural changes improve coverage. '
          'Replace lazy lists with rendered lists for SEO-critical surfaces. A ListView.builder rendering thousands of items can stay lazy, but a top-level index page with twenty items is fine as a Column inside a SingleChildScrollView. The performance cost of mounting all items is negligible compared to the SEO benefit of all anchors being in the DOM. '
          'Pair every navigation gesture with a real anchor. The seo package Seo.link wraps a Flutter widget in an anchor tag with the same href that an onTap would push. Routing through the same path keeps the crawlable link and the user-facing tap in lockstep. '
          'Cross-link between detail pages. A blog post should link to related posts, a product page should link to alternatives or accessories. These "see also" patterns build a graph that Google can follow, and the graph is what surfaces orphan URLs. Even a few thoughtfully placed cross-links can move a detail page from "Discovered" to "Indexed." '
          'The sitemap remains a fallback, not a replacement. It exists to ensure that URLs are not invisible, but it cannot communicate relative importance. Internal links are where that signal lives, and for a Flutter web app, they are the difference between a discoverable site and one whose pages are perpetually queued.',
      author: 'Skia Crawley',
      date: 'March 6, 2026',
    ),
  ];
}
