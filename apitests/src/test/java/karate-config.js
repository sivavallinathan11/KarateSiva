function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    env: env,
    memberUrl: 'http://dev-int-dhp-api-membership.azurewebsites.net/',
    authUrl: 'https://login.microsoftonline.com/1400c903-3a54-41dd-a597-241ce11262da/oauth2/token',
    client_id: '64c35ac9-496b-4ffa-9cc1-369bf75e4ace',
    client_secret: 'CZ9CAueVi+SEESpGdm4R+0aq5fR0cIJGu6t+iluWHgg=',
    resource: 'https://discoveryparks.com.au/dev-int-api-v1',
    customerWebCdn: 'https://proddupe-strategicweb-cdn.azureedge.net'

  }
  if (env == 'dev') {
    
  } else if (env == 'test') {
    config.memberUrl = 'http://test-int-dhp-api-membership.azurewebsites.net/';
    config.customerWebCdn = 'https://proddupe-strategicweb-cdn.azureedge.net';
    config.client_id = '3d943fca-2431-4a91-94c9-94e6d633b789';
    config.client_secret = '=G)nDvo#+}9IJmF^9x{bH';
    config.resource = 'https://discoveryparks.com.au/test-int-api-v1';
  }

  // we don't have a mocked environment but it's here in case we want one
  if(env !== 'mock') {
    var result = karate.callSingle('classpath:signin/get-token-post.feature', config)
    config.token = result.token
  }
  return config;
}