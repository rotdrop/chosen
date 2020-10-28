class SelectParser

  constructor: ->
    @options_index = 0
    @parsed = []

  add_node: (child) ->
    if child.nodeName.toUpperCase() is "OPTGROUP"
      this.add_group child
    else
      this.add_option child

  add_group: (group) ->
    group_position = @parsed.length

    title = group.title if group.title
    title = group.getAttribute("data-original-title") if not title

    @parsed.push
      array_index: group_position
      group: true
      label: this.escape_html(group.label)
      title: title
      children: 0
      disabled: group.disabled,
      classes: group.className
    this.add_option( option, group_position, group.disabled ) for option in group.childNodes

  add_option: (option, group_position, group_disabled) ->
    if option.nodeName.toUpperCase() is "OPTION"
      if option.text != ""
        if group_position?
          @parsed[group_position].children += 1

        title = option.title if option.title
        title = option.getAttribute("data-original-title") if not title
        
        @parsed.push
          array_index: @parsed.length
          options_index: @options_index
          value: option.value
          text: option.text
          html: option.innerHTML
          title: title
          selected: option.selected
          disabled: if group_disabled is true then group_disabled else option.disabled
          group_array_index: group_position
          group_label: if group_position? then @parsed[group_position].label else null
          classes: option.className
          style: option.style.cssText
      else
        @parsed.push
          array_index: @parsed.length
          options_index: @options_index
          empty: true
      @options_index += 1

SelectParser.select_to_array = (select) ->
  parser = new SelectParser()
  parser.add_node( child ) for child in select.childNodes
  parser.parsed
