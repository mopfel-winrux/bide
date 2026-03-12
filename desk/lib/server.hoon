=,  eyre
|%
+$  request-line
  $:  [ext=(unit @ta) site=(list @t)]
      args=(list [key=@t value=@t])
  ==
::  +parse-request-line: take a cord and parse out a url
::
++  parse-request-line
  |=  url=@t
  ^-  request-line
  (fall (rush url ;~(plug apat:de-purl:html yque:de-purl:html)) [[~ ~] ~])
::
++  manx-to-octs
  |=  man=manx
  ^-  octs
  (as-octt:mimes:html (en-xml:html man))
::
++  json-to-octs
  |=  jon=json
  ^-  octs
  (as-octs:mimes:html (en:json:html jon))
::
++  app
  |%
  ++  give-simple-payload
    |=  [eyre-id=@ta =simple-payload:http]
    ^-  (list card:agent:gall)
    =/  header-cage
      [%http-response-header !>(response-header.simple-payload)]
    =/  data-cage
      [%http-response-data !>(data.simple-payload)]
    :~  [%give %fact ~[/http-response/[eyre-id]] header-cage]
        [%give %fact ~[/http-response/[eyre-id]] data-cage]
        [%give %kick ~[/http-response/[eyre-id]] ~]
    ==
  --
++  gen
  |%
  ++  max-1-da  ['cache-control' 'max-age=86400']
  ++  max-1-wk  ['cache-control' 'max-age=604800']
  ::
  ++  html-response
    =|  cache=?
    |=  =octs
    ^-  simple-payload:http
    :_  `octs
    [200 [['content-type' 'text/html'] ?:(cache [max-1-wk ~] ~)]]
  ::
  ++  css-response
    =|  cache=?
    |=  =octs
    ^-  simple-payload:http
    :_  `octs
    [200 [['content-type' 'text/css'] ?:(cache [max-1-wk ~] ~)]]
  ::
  ++  js-response
    =|  cache=?
    |=  =octs
    ^-  simple-payload:http
    :_  `octs
    [200 [['content-type' 'text/javascript'] ?:(cache [max-1-wk ~] ~)]]
  ::
  ++  json-response
    =|  cache=_|
    |=  =json
    ^-  simple-payload:http
    :_  `(json-to-octs json)
    [200 [['content-type' 'application/json'] ?:(cache [max-1-da ~] ~)]]
  ::
  ++  manx-response
    =|  cache=_|
    |=  man=manx
    ^-  simple-payload:http
    :_  `(manx-to-octs man)
    [200 [['content-type' 'text/html'] ?:(cache [max-1-da ~] ~)]]
  ::
  ++  not-found
    ^-  simple-payload:http
    [[404 ~] ~]
  ::
  ++  login-redirect
    |=  =request:http
    ^-  simple-payload:http
    =-  [[307 ['location' -]~] ~]
    %^  cat  3
      '/~/login?redirect='
    url.request
  ::
  ++  redirect
    |=  redirect=cord
    ^-  simple-payload:http
    [[307 ['location' redirect]~] ~]
  --
--
