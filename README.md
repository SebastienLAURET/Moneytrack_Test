# Moneytrack backend Test

## Instructions of the test
Clone this repository and create a copy on your own github or gitlab account (<b>please do not fork it</b>).
For each exercise, commit and push your changes to your repository.
We encourage you to implement tests in your code in order to ease its implementation.
You have 2:30 for responding to the following questions. You're not expected to complete the whole test; do as much as you can.

## Description

We want to write a small library implementing a proof of concept of a blockchain with the capacity of following the  different versions of a random payload.
The test is divided in two parts. In the first part, we will create tools to build a chained data structure, in the second part we will build tools to audit a chained data structure. 
Feel free to start by the second part if you feel more confortable with it.

## Part 1: Build a blockchain
 
### Exercice 1
Given a payload which is a random Hash data structure. for example:

Write a class receiving a payload as input and giving the ability to:
  - serialize the payload in a specific format. Serializing should be done using the [`msgpack` gem](https://github.com/msgpack/msgpack-ruby).
  - retrieve the signature of the payload. The signature should equals `Digest::SHA256.hexdigest(serialized_payload)`, serialized_payload being specified previously.

Hint for computing serializing and signature:

```ruby
require "msgpack"
require "digest"

payload = {
  "hello" => "world",
  "key" => "value"
}


serialized = payload.to_msgpack
p "serialized: #{serialized}"
# => "serialized: \x82\xA5hello\xA5world\xA3key\xA5value"

signature = Digest::SHA256.hexdigest(serialized)
p "signature: #{signature}" 
# => "signature: ca9edf6b92aa42a4e90f8d13f114936cf64156d1d54e00af931ae5e7a24cae28"

```


### Exercice 2
We now want to create a data structure allowing to follow in a chain the successive modifications of the payload, which will be an array of `block`. Let’s call it a `blockchain`.

Each `block` will have the following format:
 - `header`: a Header containing the following information:
    - `timestamp`: the UTC timestamp of the creation of the payload serialized with the iso8601 format ( `Time.now.utc.iso8601` )
    - `previous_block`: the hash of the previous version of the data (nil for the initial version).
    - `payload_signature`: the SHA256 signature of the serialized payload.
- `signature`: The signature of the `header` (computed using the same algorithm as the one used to compute the payload signature)


The following code snippet illustrates what could look like our data structure (note that the hash value may not be correct in this example):
 
```ruby
# First Block
{
    signature: "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08",
    payload_serialized: "\x82\xA5hello\xA5world\xA4key1\xA6value1",
    header: {
      timestamp:  "2018-10-16T10:17:45Z",
      previous_block: nil,
      payload_signature: "3a87af5e8ceb519b74e02a2cfde90a12faa34f0f9142b033e5338acab58b18e5"
    }
}

# Second Block
{
    signature: "7e0b04850054fcdad9b4f9a4eecf77ac0f433fbf8788100d371a0e83398a6533",
    payload_serialized: "\x82\xA5hello\xA5world\xA4key1\xABother_value",
    header: {
        timestamp: "2018-10-16T10:31:45Z",
        previous_block: "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08",
        payload_signature: "7e0b04850054fcdad9b4f9a4eecf77ac0f433fbf8788100d371a0e83398a6533",
    }
}

# Third Block
{
    signature: "573a093cca64cfcd7f90748d3f6906dff85eaed99f45dc7693256b6d210209fa",
    payload_serialized: "\x83\xA5hello\xA5world\xA4key1\xABother_value\xA4key2\xA9new value",
    header: {
        timestamp: "2018-10-16T10:31:45Z",
        previous_block: "7e0b04850054fcdad9b4f9a4eecf77ac0f433fbf8788100d371a0e83398a6533",
        payload_signature: "8df7148644ffa88f9fce4b43fd29776afb9c8b93e856097db332ed268604ad29",
    }
}

```

Write the necessary code which will allow to:
- Create a new `block`, taking as input a `payload`, the signature of the previous block and optionnaly the timestamp (default being the current time). This block can be serialized in the previously defined format.
- Create a new `blockchain`, taking as input the initial value of the `payload`.
- Add a block to the `blockchain`, taking as input the new value of the `payload`.

### Exercice 3

Write the necessary code to allow:
  - taking an Array as input. Each element of the array corresponds to a version of the payload (all blocks will be timestamped to the current time).
  - printing as a result a human readable `blockchain` data structure computed from the input.

```ruby
# example output:
[{:signature=>
   "25b820286a1167ed3485d8510bf7b15135467e1203da81590beca3d901b20293",
  :header=>
   {:timestamp=>"2018-10-16T16:40:53Z",
    :previous_block=>nil,
    :payload_signature=>
     "3a87af5e8ceb519b74e02a2cfde90a12faa34f0f9142b033e5338acab58b18e5"},
  :payload=>{"hello"=>"world", "key1"=>"value1"}},
 {:signature=>
   "7128fdfbe9448990942233b4c19b50220b69db16b92272bbb4c4f98155117b0f",
  :header=>
   {:timestamp=>"2018-10-16T16:40:53Z",
    :previous_block=>
     "25b820286a1167ed3485d8510bf7b15135467e1203da81590beca3d901b20293",
    :payload_signature=>
     "7abc00bcc90ddce7c352c011b35760d2b1a5a0acd2abf856440090f3257c47bf"},
  :payload=>{"hello"=>"world", "key1"=>"value1", "key2"=>"value2"}},
 {:signature=>
   "bd8ad64122ff667c3a23454f982edd324ee069716cd40c47ee34b2297905308f",
  :header=>
   {:timestamp=>"2018-10-16T16:40:53Z",
    :previous_block=>
     "7128fdfbe9448990942233b4c19b50220b69db16b92272bbb4c4f98155117b0f",
    :payload_signature=>
     "efaaa9f4a61f715d691193b883edd83d84765234dbc3be8c456d93f8a4ec2293"},
  :payload=>{"hello"=>"world", "key2"=>"value2"}},
 {:signature=>
   "0ed7e9b8ee0ae52490ba69db334d3dc35148481ed9b34e17a20a4caa37f1864d",
  :header=>
   {:timestamp=>"2018-10-16T16:40:53Z",
    :previous_block=>
     "bd8ad64122ff667c3a23454f982edd324ee069716cd40c47ee34b2297905308f",
    :payload_signature=>
     "094ff398fcdca678695f9c909ee45fd9c6b0e34a465355943064b2beb6098c60"},
  :payload=>{"hello"=>"world", "key2"=>"value2", "another"=>"value"}}]
  
``` 
 
## Part 2: Audit a blockchain
 
## Exercice 4

Given a `blockchain` data structure as previously specified, write a piece of code which will have the ability to:
- check the consistency of a blockchain data structure. a `blockchain` will be considered as consistent when 
    - For each block:
        - the `payload_signature` is consistent with the serialized_payload.
        - the `previous_block` equals the previous block `signature`.
        - the `signature` is consistent with the header.
- find the last consistent `block` of a `blockchain` data structure and the reason of the inconsistency.
- print in a human readable format the contain of a `blockchain`.