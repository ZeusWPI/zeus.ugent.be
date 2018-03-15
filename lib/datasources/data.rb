class DataDataSource < Nanoc::DataSource
  identifier :data

  def items
    item = new_item(
      '',
      # TODO: Fix creating a wrapper object
      # Right now circumventing a bug which requires k,v pairs
      # instead of lists. Else the associated attributes are
      # indexed by an integer instead of a string/symbol
      { data: YAML.load_file('data/bestuur.yaml') },
      Nanoc::Identifier.new('/data/bestuur')
    )

    [item]
  end
end
