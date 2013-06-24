# bio-jplace

[![Build Status](https://secure.travis-ci.org/wwood/bioruby-jplace.png)](http://travis-ci.org/wwood/bioruby-jplace)

Jplace format file parser for ruby. Parses the file format described at http://www.plosone.org/article/info%3Adoi%2F10.1371%2Fjournal.pone.0031009

## Installation

```sh
gem install bio-jplace
```

## Usage

An example jplace format file, from https://en.wikipedia.org/wiki/Stockholm_format
```json
{
 "tree": "((A:0.2{0},B:0.09{1}):0.7{2},C:0.5{3}){​4};",
 "placements":
 [
  {"p":
   [[1, −2578.16, 0.777385, 0.004132, 0.0006],
   [0, −2580.15, 0.107065, 0.000009, 0.0153]
   ],
  "n": ["fragment1", "fragment2"]
  },
  {"p": [[2, −2576.46, 1.0, 0.003555, 0.000006]],
   "nm": [["fragment3", 1.5], ["fragment4", 2]]}
 ],
 "metadata":
 {"invocation":
  "pplacer -c tiny.refpkg frags.fasta"
 },
 "version": 3,
 "fields":
 ["edge_num", "likelihood", "like_weight_ratio",
    "distal_length", "pendant_length"]
}
```

```ruby
require 'bio-jplace'

jplace = Bio::Jplace.parse('spec/data/example.jplace') #=> Bio::Jplace object

jplace.version #=> 3 (Integer)
jplace.tree #=> Bio::Jplace::Tree object, containing the tree "((A:0.2{0},B:0.09{1}):0.7{2},C:0.5{3}){​4};"

jplace.each_placement do |placement|
  placement.names #=> Array of Bio::Jplace::Name objects, which may contain multiplicity information
end

jplace.fields #=> ["edge_num", "likelihood", "like_weight_ratio",
    "distal_length", "pendant_length"]
```

The API doc is online. For more code examples see the test files in
the source tree.
        
## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/wwood/bioruby-jplace

The BioRuby community is on IRC server: irc.freenode.org, channel: #bioruby.

## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at (http://biogems.info/index.html#bio-jplace)

## Copyright

Copyright (c) 2013 Ben J. Woodcroft. See LICENSE.txt for further details.

