#!/usr/bin/env ruby
require File.expand_path(File.dirname(__FILE__) + "/spec_helper")

describe "JplaceParser" do
  jplace = Bio::Jplace.parse_file File.open(File.join TEST_DATA_DIR, "jsonsample.json")

  it "should return tree" do
    data = jplace.tree
    data.should be_kind_of(Bio::Jplace::Tree)
    data.tree_string.should  == "((A:0.2{0},B:0.09{1}):0.7{2},C:0.5{3}){4};"
    data.newick.should == "((A:0.2,B:0.09):0.7,C:0.5);"
  end

  it "should return metadata" do
    data = jplace.metadata()
    data["invocation"].should == "pplacer -c tiny.refpkg frags.fasta"
  end

  it "should return version" do
    data = jplace.version
    data.should == 3
  end

  it "fields should return fields" do
    data = jplace.fields
    data.should == ["edge_num", "likelihood", "like_weight_ratio", "distal_length", "pendant_length"]
  end

  it "fieldvalue should return should return fieldvalue for fragment 7" do
    data = jplace.field_value("fragment7", "likelihood")
    data.should == [22576.46]
  end

  it "multiplicity should return multiplicity for fragment 7" do
    data = jplace.multiplicity("fragment7")
    data.should == 4.676
  end

  it "getplacment should return placement for fragment 7" do
    data1 = jplace.placements("fragment7")
    data1.should be_kind_of(Array)
    data1.length.should == 1
    data=data1[0]
    data["edge_num"].should == 5
    data["likelihood"].should == 22576.46
    data["like_weight_ratio"].should == 1.0
    data["distal_length"].should == 0.003555
    data["pendant_length"].should == 0.000006
  end

  it 'should return 2 placements when two are specified in the jplace' do
    placements = jplace.placements("fragment1")
    placements.should be_kind_of(Array)
    placements.length.should == 2
  end

  it "each_placment_set should return 7 fragments" do
    fragmentcount= 0
    jplace.each_placement_set do |out, pos, mult|
      fragmentcount += 1
    end
    fragmentcount.should == 7
  end
end
