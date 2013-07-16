class ApkParser
  require 'xml'
  require 'zip/zip'

  END_DOC_TAG = 0x00100101
  START_TAG = 0x00100102
  END_TAG = 0x00100103
  MAX_INT = 4294967295

  @@apk_cache = {}

  def initialize(file)
    @xml = manifest_xml(file)
    @doc = XML::Parser.string(@xml).parse
  end

  def xml
    @xml
  end

  def package_id
    @doc.find_first('//manifest/@package').value
  end

  def name
    @doc.find_first('//manifest/application/@name').value
  end

  def version
    @doc.find_first('//manifest/@versionname').value
  end

  protected

  def xml_tag_offset(data)
    offset = read_word(data, 12)

    # Find the start tag
    i = 0
    while i < data.length - 4 do
      if read_word(data, i) == START_TAG
        offset = i
        break
      end
      i += 4
    end

    offset
  end

  def get_data(file)
    data = nil

    # Get just the AndroidManifest.xml from the APK file
    Zip::ZipFile.foreach(file) do |f|
      if f.name.match(/AndroidManifest.xml/)
        data = f.get_input_stream.read
      end
    end

    data
  end

  def xml_output(data)
    num_strings = read_word(data, 16)

    # String index table offset, string table offset
    sit_offset = 36
    st_offset = sit_offset + num_strings * 4

    offset = xml_tag_offset data
    start_tag_line_num = -2

    output = ""

    # Read the document
    while (offset < data.length)
      tag0 = read_word(data, offset)
      line_num = read_word(data, offset + 8)
      name_ns_si = read_word(data, offset + 16)
      name_si = read_word(data, offset + 20)

      # Opening XML tag
      if tag0 == START_TAG
        tag6 = read_word(data, offset + 24)
        num_attrs = read_word(data, offset + 28)

        offset += 36

        name = get_string(data, sit_offset, st_offset, name_si)

        start_tag_line_num = line_num

        attr_string = ""

        # Handle attributes
        (0...num_attrs).each do |i|
          attr_names_ns_si = read_word(data, offset)
          attr_name_si = read_word(data, offset + 4)
          attr_value_si = read_word(data, offset + 8)
          attr_flags = read_word(data, offset + 12)
          attr_res_id = read_word(data, offset + 16)

          offset += 20

          attr_name = get_string(data, sit_offset, st_offset, attr_name_si)

          # If the attribute doesn't have a value, note the resource ID
          attr_value = attr_value_si != MAX_INT ? 
            get_string(data, sit_offset, st_offset, attr_value_si) :
            "0x#{attr_res_id.to_s(16)}"

          # Build the XML attribute string
          attr_string << " #{attr_name.downcase}='#{attr_value}'"
        end

        # Build the opening XML tag with attributes
        line = "<#{name.downcase}#{attr_string}>"
        output << line

        # Closing XML tag
      elsif tag0 == END_TAG
        offset += 24
        name = get_string(data, sit_offset, st_offset, name_si)

        # Build the XML closing tag
        line = "</#{name.downcase}>"

        output << line

        # Found the end, we're done
      elsif tag0 == END_DOC_TAG
        break
      end
    end
    output
  end

  def manifest_xml(file, opts = {})
    return @@apk_cache[file] if @@apk_cache[file] && opts[:force_reload].blank?

    data = get_data file

    xml_output data 
  end

  # Read a 32-bit word from a specific location in the data
  def read_word(data, offset)
    out = data[offset,4].unpack('V').first rescue 0
  end

  # Get a string from the data
  def get_string(data, sit_offset, st_offset, string_index)
    return nil if string_index < 0

    # Figure out where the string is based on the index table offsets
    string_offset = st_offset + read_word(data, sit_offset + string_index * 4)

    string_length = data[string_offset,2].unpack('v').first

    string = ""

    (0...string_length).each do |i|
      # Hack to skip over weird characters
      string << data[string_offset + 2 + i*2]
    end

    return string
  end
end
