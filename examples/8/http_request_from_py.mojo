from python import Python

fn main() raises:
    let requests = Python.import_module("requests")
    let response = requests.get("https://www.standaard.be/")
    print(response.text)

# =>
# <!doctype html>
# <html class="m_no-js oneplatform_renderFragmentServerSide_mostread conv_enableSegmentedOffer openam temp_liveFeedOnArticleDetail conv_activationwall oneplatform_renderFragmentServerSide_articlelist conv_subscriptionWall enableThirdPartySocialShareService video_enableSpark web_temp_enableWetterKontorIntegration temp_useScribbleLiveApi oneplatform_renderFragmentServerSide_particles paywall_porous_isEnabled temp_enableAddressServiceApi oneplatform_renderFragmentServerSide_articledetail temp_web_enableSeparateDfpScript video_enableAutoplay paywall_metering_v2 web_temp_enableNewGdpr temp_sportMappingViaDb conv_useConversionFlows oneplatform_renderFragmentServerSide_articlegrid oneplatform_fragment_enableMenus aboshop_pormax oneplatform_renderFragmentServerSide_singlearticle temp_useAMConfiguration oneplatform_renderFragmentServerSide_search accountConsent_showPopups conv_loginwall conv_passwordreset com_pushnotificationsOptinboxEnabled temp_newHeader enableReadLater paywall_bypassPaywallForBots PERF_DisableArticleUpdateCounters accountinfo_not_getidentity " dir="ltr" lang="nl-BE">
# <head>
#     <meta charset="utf-8">

#     <link rel="shortcut icon" href="https://www.standaard.be/extra/assets/img/faviconLive.ico"/>
#     <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    
#       <title>De Standaard</title>
    
#         <link rel="alternate" media="only screen and (max-width: 640px)" href="https://m.standaard.be" />
#         <link rel="alternate" media="handheld" href="https://m.standaard.be" />
#     <meta name="cXenseParse:mhu-article_ispaidcontent" content="false" />    
#     <meta name="cXenseParse:mhu-domain" content="ds-live" />    
#     <meta name="cXenseParse:Taxonomy" content="ds-live" />    
#     <meta name="description" content="Het meest recente nieuws uit Belgi&#235; en het buitenland, economie en geld, cultuur, sport en lifestyle. Lees online de krant en DS Avond." />    
#     <meta property="fb:admins" content="1031588996" />    
#     <meta property="fb:admins" content="100006909940815" />    
#     <meta property="fb:app_id" content="155215551216365" />    
#     <meta property="fb:pages" content="7133374462" />    
#     <meta property="og:image" content="https://www.standaard.be/extra/assets/img/dummy-social.gif" />    
#     <meta property="og:site_name" content="De Standaard" />    
#     <meta property="og:title" content="De Standaard" />    
#     <meta property="og:type" content="website" />    
#     <meta property="og:url" content="https://www.standaard.be" />    
    
#     <meta name="robots" content="max-image-preview:large">

#     <!-- Mobile viewport optimized: j.mp/bplateviewport -->
#     <meta name="viewport" content="width=device-width, initial-scale=1">
#     <!-- Mobile IE allows us to activate ClearType technology for smoothing fonts for easy reading -->
#     <meta http-equiv="cleartype" content="on">
