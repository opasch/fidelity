# API Keys rules
### How create, save and manage API Keys


I want to explain how to use the Api Keys generated from Fidelize Dashboard. That's useful because we need to connect these platforms:

- The Shopping Cart
- The Fidelize Dashboard
- The Rules Engine

## General usage
Private methods must use POST and be set up as follows:

HTTP header:
```
API-Key = API key
API-Sign = A base64 encoded message signature using HMAC-SHA512 of (SHA256(nonce + POST data)) and base64 decoded of secret API key
```

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
- key_private: encoded private-key

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

// set the sign to send in header in the web request to Backend
$sign = base64_encode(hash_hmac('sha512', hash('sha256', $request['nonce'] . $postdata, true), base64_decode($privatekey), true));
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
   * @param array $_POST is the POST message
  */
  public function check()
  {

    // Retrieve payload and headers
    $headers = getallheaders();

    // Now we re-generate the POST hash
    $postdata = http_build_query($_POST, '', '&');

    // Now do the sign
    $sign = base64_encode(hash_hmac('sha512', hash('sha256', $nonce . $postdata, true), base64_decode($model->key_secret), true));

    // compare the two signatures
    if (strcmp($sign, $headers['API-Sign']) <> 0){
      die (json_encode(['success'=>false,'message'=>'Api keys are invalid!']));
    }


  }
}
```
