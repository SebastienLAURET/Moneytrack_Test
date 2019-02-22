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


The following code snippet illustrates what could look like our data structure:
 
```ruby
[
  {
    :signature => "18cc6d51e125e7ad11f37928bd5ff7e04c1ab27409180d552f9ce6db6050187c",
    :header => {
      :timestamp => "2019-02-22T17:43:48Z",
      :previous_block => nil,
      :payload_signature => "3a87af5e8ceb519b74e02a2cfde90a12faa34f0f9142b033e5338acab58b18e5"},
    :payload => {
      "hello" => "world",
      "key1" => "value1"
    }
  },
  {
    :signature => "b8b391cfda8d4e35dada2fc38102cbc408b4259ae3484d7feb00242d2edbec15",
    :header => {
      :timestamp => "2019-02-22T17:43:48Z",
      :previous_block => "18cc6d51e125e7ad11f37928bd5ff7e04c1ab27409180d552f9ce6db6050187c",
      :payload_signature => "7abc00bcc90ddce7c352c011b35760d2b1a5a0acd2abf856440090f3257c47bf"
    },
    :payload => {
      "hello" => "world",
      "key1" => "value1",
      "key2" => "value2"
    }
  },
  {
    :signature => "c5563a49e654d3c94719ca14afc4ce2b7cc0f7573938b85026e8fa9731b809d0",
    :header => {
      :timestamp => "2019-02-22T17:43:48Z",
      :previous_block => "b8b391cfda8d4e35dada2fc38102cbc408b4259ae3484d7feb00242d2edbec15",
      :payload_signature => "efaaa9f4a61f715d691193b883edd83d84765234dbc3be8c456d93f8a4ec2293"
    },
    :payload => {
      "hello" => "world",
      "key2" => "value2"
    }
  },
  {
    :signature => "4845bfd27ecc8e810a1145b4c90d0a66712ff139d68ebf1b2c55772f6d707783",
    :header => {
        :timestamp => "2019-02-22T17:43:48Z",
        :previous_block => "c5563a49e654d3c94719ca14afc4ce2b7cc0f7573938b85026e8fa9731b809d0",
        :payload_signature => "094ff398fcdca678695f9c909ee45fd9c6b0e34a465355943064b2beb6098c60"
    },
    :payload => {
      "hello" => "world",
      "key2" => "value2",
      "another" => "value"
    }
  }
]
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
   "18cc6d51e125e7ad11f37928bd5ff7e04c1ab27409180d552f9ce6db6050187c",
  :header=>
   {:timestamp=>"2019-02-22T17:43:48Z",
    :previous_block=>nil,
    :payload_signature=>
     "3a87af5e8ceb519b74e02a2cfde90a12faa34f0f9142b033e5338acab58b18e5"},
  :payload=>{"hello"=>"world", "key1"=>"value1"}},
 {:signature=>
   "b8b391cfda8d4e35dada2fc38102cbc408b4259ae3484d7feb00242d2edbec15",
  :header=>
   {:timestamp=>"2019-02-22T17:43:48Z",
    :previous_block=>
     "18cc6d51e125e7ad11f37928bd5ff7e04c1ab27409180d552f9ce6db6050187c",
    :payload_signature=>
     "7abc00bcc90ddce7c352c011b35760d2b1a5a0acd2abf856440090f3257c47bf"},
  :payload=>{"hello"=>"world", "key1"=>"value1", "key2"=>"value2"}},
 {:signature=>
   "c5563a49e654d3c94719ca14afc4ce2b7cc0f7573938b85026e8fa9731b809d0",
  :header=>
   {:timestamp=>"2019-02-22T17:43:48Z",
    :previous_block=>
     "b8b391cfda8d4e35dada2fc38102cbc408b4259ae3484d7feb00242d2edbec15",
    :payload_signature=>
     "efaaa9f4a61f715d691193b883edd83d84765234dbc3be8c456d93f8a4ec2293"},
  :payload=>{"hello"=>"world", "key2"=>"value2"}},
 {:signature=>
   "4845bfd27ecc8e810a1145b4c90d0a66712ff139d68ebf1b2c55772f6d707783",
  :header=>
   {:timestamp=>"2019-02-22T17:43:48Z",
    :previous_block=>
     "c5563a49e654d3c94719ca14afc4ce2b7cc0f7573938b85026e8fa9731b809d0",
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