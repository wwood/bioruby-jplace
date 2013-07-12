require 'json'

module Bio
  class Jplace
    def initialize(io_object)
      @json = JSON.parse io_object.read
    end

    def self.parse_file(file_path)
      self.new File.open(file_path)
    end

    def tree
      Tree.new @json['tree']
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

    # Return an array of values for a given placement key (name),
    # one value for each placement
    def field_value(name, field)
      placement_collection[name].collect{|entry| entry[field]}
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

      return toReturn
    end

    def placements(name)
      placement_collection[name]
    end

    def each_placement_set
      placement_collection.each do |name, field_hash|
        set = PlacementSet.new(fields, field_hash)
        set.multiplicity = multiplicity(name)
        yield name,
          set,
          set.multiplicity
      end
    end

    private
    def placement_collection
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
          raise "Error while parsing jplace file, expected n or nm for each p. Current p is #{p.inspect}"
        end
      end
      nphash = nmhash.merge(nhash)
      return nphash
    end


    # A class to represent the tree that is given in Jplace formats
    # e.g. "((A:0.2{0},B:0.09{1}):0.7{2},C:0.5{3}){4};"
    class Tree
      attr_accessor :tree_string

      def initialize(tree_string)
        @tree_string = tree_string
      end

      # Return a newick format tree, with the branch labels removed.
      def newick
        @tree_string.gsub /\{\d+\}/, ''
      end
    end

    class PlacementSet
      attr_accessor :placements
      attr_accessor :multiplicity

      # Create a new PlacementSet object with the field names specified
      # in the jplace file, and an array of placement values, which is
      # an array of array of values (an entry for each placement, then and
      # entry for each value in that specific placement).
      def initialize(field_names, placement_values)
        @placements = []
        placement_values.each do |place_vals|
          @placements.push Placement.new(field_names, place_vals)
        end
      end

      # Return the index'th Bio::Jplace::Placement object in this set
      def [](index)
        @placements[index]
      end
    end

    class Placement
      def initialize(field_names, attributes)
        raise unless field_names.length == attributes.length
        @attribute_values = {}
        field_names.each_with_index do |field_name, i|
          @attribute_values[field_name] = attributes[i]
        end
      end

      def [](field_name)
        @attribute_values[field_name]
      end
    end
  end
end
