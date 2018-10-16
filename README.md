# Moneytrack backend Test

## Instructions of the test
Clone this repository and create a copy on your own github or gitlab account (<b>please do not fork it</b>).
For each exercise, commit and push your changes to your repository.
We encourage you to implement tests in your code in order to ease its implementation.

## Description

We want to write a small library implementing a proof of concept of a blockchain with the capacity of following the  different versions of a random payload.

 
## Exercice 1:
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


## Exercice 2:
We now want to create a data structure allowing to follow in a chain the different modifications of the payload. Let's call it `blockchain` 

Each `block` will have the following format:
 - `header`: a Header containing the following information:
    - `timestamp`: the UTC timestamp of the creation of the payload serialized with the iso8601 format ( `Time.now.utc.iso8601` )
    - `previous_hash`: the hash of the previous version of the data (nil for the initial version).
    - `data_hash`: the SHA256 signature of the serialized payload.
- `hash`: The signature of the `header` (computed using the same algorithm as the one used to compute the payload signature)


The following code snippet illustrates what could look like our data structure (note that the hash value may not be correct in this example):
 
```ruby
# First Block
{
    hash: "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08",
    serialized_payload: "\x82\xA5hello\xA5world\xA4key1\xA6value1",
    header: {
      timestamp:  "2018-10-16T10:17:45Z",
      previous_hash: nil,
      data_hash: "3a87af5e8ceb519b74e02a2cfde90a12faa34f0f9142b033e5338acab58b18e5"
    }
}

# Second Block
{
    hash: "7e0b04850054fcdad9b4f9a4eecf77ac0f433fbf8788100d371a0e83398a6533",
    serialized_data: "\x82\xA5hello\xA5world\xA4key1\xABother_value",
    header: {
        timestamp: "2018-10-16T10:31:45Z",
        previous_hash: "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08",
        data_hash: "7e0b04850054fcdad9b4f9a4eecf77ac0f433fbf8788100d371a0e83398a6533",
    }
}

# Third Block
{
    hash: "573a093cca64cfcd7f90748d3f6906dff85eaed99f45dc7693256b6d210209fa",
    serialized_data: "\x83\xA5hello\xA5world\xA4key1\xABother_value\xA4key2\xA9new value",
    header: {
        timestamp: "2018-10-16T10:31:45Z",
        previous_hash: "7e0b04850054fcdad9b4f9a4eecf77ac0f433fbf8788100d371a0e83398a6533",
        data_hash: "8df7148644ffa88f9fce4b43fd29776afb9c8b93e856097db332ed268604ad29",
    }
}

```

Write a piece of code which will allow to:
- Create a new `blockchain`, taking as input the initial value of the `payload`.
- Add a block to the `blockchain`, taking as input the new value of the `payload`.

## Exercice 3

Write a piece of code which 
  - can take an Array as input. Each element of the array corresponds to a version of the payload.
  - outputs a `blockchain` data structure computed from the input.
 
 
## Exercice 4

Given a `blockchain` data structure as previously specified, write a piece of code which will have the ability to:
- check the consistency of a blockchain data structure. a blockchain will be considered as consistent when 
    - For each block:
        - the data_hash is consistent with the serialized_payload.
        - the previous_hash points to a valid block.
        - the hash is consistent with the header.
    - no conflict exisit between blocks (each block is referenced by a single son)
- find the last consistent block of a blockchain data structure and the reason of the inconsistency.
- print in a human readable format the different versions of the blockchain. 