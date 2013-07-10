#!/usr/bin/env ruby

require 'pp'
require 'rubygems'
require 'json'

class Jplace
  def initialize(data)
    @json = data
    placementCollection
  end

  def tree
    @json['tree']
  end

  def metadata
    @json['metadata']
  end

  def version
    @json['version']
  end

  def fields
    @json['fields']
  end

  def placementCollection
    npos=[]
    nmpos=[]
    nhash={}
    nmhash={}
    nphash={}
    @json['placements'].each do |placement|
      if placement['n']
        nstring=placement['n']
        nstring.each do |nname|
          identifier = nname
          pstring = placement['p']
          nwrite=[]
          pstring.each do |position|
            fields = @json['fields']
            npstringfieldhash={}
            ntempwrite=[]
            fields.each_with_index do |nentry, nindex|
              npstringfieldhash[nentry]= position[nindex]
            end
            nwrite << npstringfieldhash
            npstringfieldhash={}
          end
          npos=nwrite
          nhash[identifier]=npos
        end
      elsif placement['nm']
        placement['nm'].each do |nmname|
          nmpstring = placement['p']
          write = []
          nmpstring.each do |nmposition|
            identifier = nmname[0]
            fields = @json['fields']
            nmpstringfieldhash={}
            tempwrite=[]
            fields.each_with_index do |entry,index|
              nmpstringfieldhash[entry]= nmposition[index]
            end
            write << nmpstringfieldhash
            nmpstringfieldhash={}
            nmpos=write
            nmhash[identifier]=nmpos
          end
        end
      else
        raise "Bad dataset, please check your .jsonfile, expect n or nm for each p"
      end
    end
    nphash = nmhash.merge(nhash)
    @placementCollection = nphash
    return nphash
  end
  def fieldvalue(name, field)
  placementCollection[name].collect{|entry| entry[field]}
  end

  def multiplicity(name)
    mult={}
    @json['placements'].each do |placement|
      if placement['nm']
        placement['nm'].each do |nmname|
          pstring = placement['p']
          write = []
          pstring.each do |position|
            identifier = nmname[0]
            multiplicity = nmname[1]
            mult[identifier]=multiplicity
          end
        end
      end
    end
    toReturn=mult[name]
    toReturn=toReturn.to_f if mult[name]
    @multiplicity = mult

    return toReturn
  end

  def getplacement(name)
    placementCollection[name]
  end

  def each_placement_set
    placementCollection.each do |key, val|
      yield key, val, multiplicity(key)
    end
  end
end
#######################################################

