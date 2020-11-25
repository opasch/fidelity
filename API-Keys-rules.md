# API Keys rules
### How create, save and manage API Keys


I want to explain how to use the Api Keys generated from Fidelize Dashboard. That's useful because we need to connect these platforms:

- The Shopping Cart
- The Fidelize Dashboard
- The Rules Engine

## Generate API Keys betwen Dashboard and Rules Engine
The 1st connection we want to create is between the Dashboard and the Rules engine. Then, we'll use the same process to connect the shopping cart to the dashboard.

Well, we start to login with an Administrator user into the Fidelize Dashboard and go in modify Settings.
We choose the "Rules Engine Api Keys" tab and push the button "CREATE".

The software will show us two codes:
- a public key (ex. 90L1aSxCtsI3EhenlZc78gmk)
- a private key (ex. h.!I/Uj2HPu1YZcJOZp@La89DN,34KQSYLNtgv&60=yM(u*exfrvVXSnidODRdml)

This is our only chance to copy the private key, as it will no longer be shown.

#### Saving keys
The Fidelize Dashboard software save the keys in this two fields
- key_public: public key in clear text
- key_private: md5(public-key + private-key)

__The RULES ENGINE must find a way to save the private key, perhaps encrypting it with its own system.__


## Generate API Keys betwen Dashboard and Shopping Cart
Now we connect to Fidelize dashboard by an user account.
In the API Keys menu we can select "CREATE" and the software will show us the public and private keys.
OK, now the shopping cart plugin save these two keys for future use.



## How the Shopping cart plugin works
The Shopping cart plugin, after a purchase, sends a POST message to the Fidelize Dashboard backend. The message must be prepared in this way:

```php
<?php
// variables
$_POST // is the POST message from web server request
$publicKey // is the public key
$privatekey // is the private key

// generate a 64 bit nonce using a timestamp at microsecond resolution
// string functions are used to avoid problems on 32 bit systems
$nonce = explode(' ', microtime());

// set first (in alphabetic order) 'data' and then 'nonce'
$request['data'] = $_POST ,true);
$request['nonce'] = $nonce[1] . str_pad(substr($nonce[0], 2, 6), 6, '0');

// build the POST data string
$postdata = http_build_query($request, '', '&');

// set the private key
$X_PRIVATE_KEY = md5($publicKey . $privateKey);

// set the sign to send in header in the web request to Backend
$sign = base64_encode(hash_hmac('sha512', hash('sha256', $request['nonce'] . $postdata, true), base64_decode($X_PRIVATE_KEY), true));
```

With the generated __sign__ we can now send the POST message to the Fidelize backend of the dashboard. In the headers of message we must set these parameters:
- API-Key: the public key
- API-Sign: the generated sign


## How the Fidelize Dashboard backend works
The backend analizes the POST message received from Shopping cart plugin.

```php
<?php
// 2 seconds for margin of error
define ('NONCE_STEP',2);

class APIKeys
{
  /**
   * This function checks the API Keys
   *
   * @param array $request is the POST message
  */
  public function check($request)
  {
    if (!function_exists('getallheaders')) {
      function getallheaders() {
        $headers = [];
        foreach ($_SERVER as $name => $value) {
          if (substr($name, 0, 5) == 'HTTP_') {
            $headers[str_replace(' ', '-', ucwords(strtolower(str_replace('_', ' ', substr($name, 5)))))] = $value;
          }
        }
        return $headers;
      }
    }

    $securityToken = null;
    $post = json_decode($_POST['data']);
    $headers = getallheaders();

    // check if the message is outdated
    $microtime = explode(' ', microtime());
    $nonce = $microtime[1] . str_pad(substr($microtime[0], 2, 6), 6, '0');
    if (($nonce/1000000 - $post->nonce/1000000) > NONCE_STEP)
      die (json_encode(['success'=>false,'message'=>'Data is outdated!']));

    foreach ($headers as $name => $value) {
      if (strtoupper($name) == 'API-KEY'){
        // Load the Api keys from table to check existence
        $model = Api::model()->findByAttributes(['key_public'=>$value]);
        if (null === $model)
          die (json_encode(['success'=>false,'message'=>'Public key doesn\'t exist!']));

        // Now we re-generate the POST hash
        $request['data'] = print_r($post->data,true);
        $request['nonce'] = $post->nonce;
        $postdata = http_build_query($request, '', '&');

        $sign = base64_encode(hash_hmac('sha512', hash('sha256', $post->nonce . $postdata, true), base64_decode($model->key_secret), true));

        if (strcmp($sign, $headers['API-Sign']) !== 0)
          die (json_encode(['success'=>false,'message'=>'Api keys are invalid!']));

        return $post->data;
      }
    }
  }
}
```
