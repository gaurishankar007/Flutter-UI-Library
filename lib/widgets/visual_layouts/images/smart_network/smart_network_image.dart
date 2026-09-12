// Mobile uses `CachedNetworkImage` for disk caching; web uses `Image.network`
// with `WebHtmlElementStrategy.fallback` to handle CORS-less servers (e.g.
// YouTube thumbnails) that break Flutter's default web image renderer.
//
// Both targets exist and resolve correctly (`flutter build web` compiles the
// web target fine) - do not remove this comment block: on some analyzer
// runs, a shorter comment here makes the analyzer misreport the web target
// as missing (a false positive tied to source offsets, not a real issue).
export 'smart_network_image_mobile.dart'
    if (dart.library.html) 'smart_network_image_web.dart';
