#!/usr/bin/env ruby
require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

json_data=File.open("/srv/whitlam/home/users/uqtruder/scripts/bioruby-jplace/spec/data/jsonsample.json").read
data = JSON.parse(json_data)
jplace = Jplace.new(data)

describe "JsonParser" do

  it "should return tree" do
    data = jplace.tree()
    data.should  == "((A:0.2{0},B:0.09{1}):0.7{2},C:0.5{3}){4};"
  end

  it "should return metadata" do
    data = jplace.metadata()
    data["invocation"].should == "pplacer -c tiny.refpkg frags.fasta"
  end

  it "should return version" do
    data = jplace.version()
    data.should == 3
  end

  it "fields should return fields" do
    data = jplace.fields
    data.should == ["edge_num", "likelihood", "like_weight_ratio", "distal_length", "pendant_length"]
  end

  it "fieldvalue should return should return fieldvalue for fragment 7" do
    data = jplace.fieldvalue("fragment7", "likelihood")
    data.should == [22576.46]
  end

  it "multiplicity should return multiplicity for fragment 7" do
    data = jplace.multiplicity("fragment7")
    data.should == 4.676
  end

  it "getplacment should return placement for fragment 7" do
    data1 = jplace.getplacement("fragment7")
    data=data1[0]
    data["edge_num"].should == 5
    data["likelihood"].should == 22576.46
    data["like_weight_ratio"].should == 1.0
    data["distal_length"].should == 0.003555
    data["pendant_length"].should == 0.000006
  end

  it "each_placment_set should return 7 fragments" do
    fragmentcount= 0
    jplace.each_placement_set do |out, pos, mult|
    fragmentcount += 1
    end
    fragmentcount.should == 7
  end
end
