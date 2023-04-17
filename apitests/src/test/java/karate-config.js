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
    customerWebCdn: 'https://proddupe-strategicweb-cdn.azureedge.net',
    crmWebUrl: 'https://discoveryparksdev.crm6.dynamics.com/api/data/v8.2',
    crm_AuthUrl: 'https://login.microsoftonline.com/1400c903-3a54-41dd-a597-241ce11262da/oauth2/token',
    crm_ClientId: '29e2dad5-205a-4780-adff-4d7e7e219f97',
    crm_ClientSecret: 'ddd662e2-b64a-4c56-aa6e-acfe8797cdde',
    crm_Resource: 'https://discoveryparksdev.crm6.dynamics.com/',
  }
  if (env == 'dev') {
    
  } else if (env == 'test') {
    config.memberUrl = 'http://test-int-dhp-api-membership.azurewebsites.net/';
    config.customerWebCdn = 'https://proddupe-strategicweb-cdn.azureedge.net';
    config.client_id = '3d943fca-2431-4a91-94c9-94e6d633b789';
    config.client_secret = '=G)nDvo#+}9IJmF^9x{bH';
    config.resource = 'https://discoveryparks.com.au/test-int-api-v1';
    config.crmWebUrl= 'https://discoveryparkstest.crm6.dynamics.com/api/data/v8.2';
    config.crm_ClientId = 'a50d2e6e-1e6f-4794-b2cc-19d2e9e74d2a';
    config.crm_ClientSecret = '2a477537-40a0-481f-ba4e-27b88440429b';
    config.crm_Resource = 'https://discoveryparkstest.crm6.dynamics.com/';
  } else if(env == 'memberv2'){
    config.memberUrl = 'https://test-int-dhp-api-membership-net6.azurewebsites.net/';
    config.customerWebCdn = 'https://proddupe-strategicweb-cdn.azureedge.net';
    config.client_id = '3d943fca-2431-4a91-94c9-94e6d633b789';
    config.client_secret = '=G)nDvo#+}9IJmF^9x{bH';
    config.resource = 'https://discoveryparks.com.au/test-int-api-v1';
    config.crmWebUrl= 'https://discoveryparkstest.crm6.dynamics.com/api/data/v8.2';
    config.crm_ClientId = 'a50d2e6e-1e6f-4794-b2cc-19d2e9e74d2a';
    config.crm_ClientSecret = '2a477537-40a0-481f-ba4e-27b88440429b';
    config.crm_Resource = 'https://discoveryparkstest.crm6.dynamics.com/';
}


  // we don't have a mocked environment but it's here in case we want one
  if(env !== 'mock') {
    // this will get a token once and use it for all tests
    var result = karate.callSingle('classpath:signin/get-token-post.feature', config)
    // this sets the header for all api calls
    karate.configure('headers', { 'Authorization': result.token });
    config.token = result.token
  }
  return config;
}