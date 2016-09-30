(($) ->
  $.attachinary =
    index: 0
    config:
      disableWith: 'Uploading...'
      indicateProgress: true
      invalidFormatMessage: 'Invalid file format'
      template: """
        <table class='gigantic-table'>
          <thead>
            <th class='gigantic-table-head__file'><%= (options && options.labels && options.labels.files) ? options.labels.files : 'Fichier' %></th>
            <th class='gigantic-table-head__status'><%= (options && options.labels && options.labels.status) ? options.labels.status : 'Statut' %></th>
          </thead>
          <tbody>
            <% for(var i=0; i<files.length; i++){ %>
              <tr class='gigantic-table--row'>
                <td class='relative-path'>
                  <%= files[i].relative_path %>
                </td>
                <td class='status <%= files[i].confirmed ? 'confirmed' : (files[i].handled ? 'wip' : '') %>'>
                  <%= files[i].handled ? ( files[i].confirmed ? 'enregistré' : ('en cours (' + files[i].token + ')') ) : 'chargé' %>
                </td>
              </tr>
            <% } %>
          </<tbody>
        </table>
      """
      render: (files, opts) ->
        $.attachinary.Templating.template(@template, files: files, options: opts)

  $.fn.attachinary = (options) ->
    settings = $.extend {}, $.attachinary.config, options

    this.each ->
      $this = $(this)

      if !$this.data('attachinary-bond')
        $this.data 'attachinary-bond', new $.attachinary.Attachinary($this, settings)

  class $.attachinary.Attachinary
    constructor: (@$input, @config) ->
      @options = @$input.data('attachinary')

      @displayOptions = {
        labels: @config.labels
      }
      @counter = 0
      @original_token = Date.now()
      @handled_files = []
      @files = @options.files

      @$form = @$input.closest('form')
      @$submit = @$form.find(@options.submit_selector ? 'input[type=submit]')

      @$uploadStatus = $('<div>Téléchargement : 0 %</div>')
      @$form.prepend(@$uploadStatus)

      @$wrapper = @$input.closest(@options.wrapper_container_selector) if @options.wrapper_container_selector?

      @initFileUpload()
      @addFilesContainer()
      @bindEventHandlers()
      @redraw()
      @checkMaximum()

    initFileUpload: ->
      @options.field_name = @$input.attr('name')

      options =
        dataType: 'json'
        paramName: 'file'
        headers: {"X-Requested-With": "XMLHttpRequest"}
        dropZone: @config.dropZone || @$input
        sequentialUploads: true

      if @$input.attr('accept')
        options.acceptFileTypes = new RegExp("^#{@$input.attr('accept').split(",").join("|")}$", "i")

      @$input.fileupload(options)

    bindEventHandlers: ->
      @$input.bind 'fileuploadsend', (event, data) =>
        @$input.addClass 'uploading'
        @$wrapper.addClass 'uploading' if @$wrapper?
        @$form.addClass  'uploading'

        @$input.prop 'disabled', true
        if @config.disableWith
          @$submit.each (index,input) =>
            $input = $(input)
            $input.data 'old-val', $input.val() unless $input.data('old-val')?
          @$submit.val  @config.disableWith
          @$uploadStatus.text @config.disableWith
          @$submit.prop 'disabled', true

        !@maximumReached()


      @$input.bind 'fileuploaddone', (event, data) =>
        if data.files[0].webkitRelativePath
          data.result.relative_path = data.files[0].webkitRelativePath
        @addFile(data.result)


      @$input.bind 'fileuploadstart', (event) =>
        # important! changed on every file upload
        @$input = $(event.target)


      @$input.bind 'fileuploadalways', (event) =>
        @$input.removeClass 'uploading'
        @$wrapper.removeClass 'uploading' if @$wrapper?
        @$form.removeClass  'uploading'

        @checkMaximum()
        if @config.disableWith
          @$submit.each (index,input) =>
            $input = $(input)
            $input.val  $input.data('old-val')
          #@$submit.prop 'disabled', false
          fLength = @files.length + @handled_files.length
          @$uploadStatus.text "#{fLength} file#{'s' if fLength > 1} [100 %] #{@config.disableWith}"
          @$submit.remove()

      @$input.bind 'fileuploadprogressall', (e, data) =>
        progress = parseInt(data.loaded / data.total * 100, 10)
        fLength = @files.length + @handled_files.length
        if(data.loaded == data.total)
          @options.maximum = fLength
        if @config.disableWith && @config.indicateProgress
          @$submit.val "[#{progress}%] #{@config.disableWith}"
          @$uploadStatus.text "#{fLength} file#{'s' if fLength > 1} [#{progress}%] #{@config.disableWith}"

    addFile: (file) ->
      @counter = @counter + 1
      console.log("on passe ici : maximum reached ? => " + @maximumReached())
      if !@options.accept || $.inArray(file.format, @options.accept) != -1  || $.inArray(file.resource_type, @options.accept) != -1
        @files.push file
        if(@maximumReached())
          console.log("maximum reached !!! ")
        if @counter == 15 || @maximumReached()
          console.log(@counter)
          @counter = 0
          @handleFiles()
        @checkMaximum()
        @redraw()
        @$input.trigger 'attachinary:fileadded', [file]
      else
        console.log @config.invalidFormatMessage

    handleFiles: (last_call) ->
      url = this.$form[0].action
      data = JSON.stringify(@files)
      token = Date.now()

      request_params = {
        token: token
        original_token: @original_token
      }
      if(last_call)
        request_params['last_call'] = true
      request_params[@options.field_name] = data
      for file in @files
        file['token'] = token
        file['handled'] = true
        file['confirmed'] = false
        @handled_files.push file
      @files = []
      $.post url,
        request_params
        ((data, textStatus, jqXHR) ->
          console.log("success !!! => " + data)
          for file in @handled_files.filter((f, index) -> f.token.toString() == data)
            file['confirmed'] = true
          @redraw()
        ).bind(this)

    removeFile: (fileIdToRemove) ->
      _files = []
      removedFile = null
      for file in @files
        if file.public_id == fileIdToRemove
          removedFile = file
        else
          _files.push file
      @files = _files
      @redraw()
      @checkMaximum()
      @$input.trigger 'attachinary:fileremoved', [removedFile]

    checkMaximum: ->
      if @maximumReached()
        @$wrapper.addClass 'disabled' if @$wrapper?
        @$input.prop('disabled', true)
      else
        @$wrapper.removeClass 'disabled' if @$wrapper?
        @$input.prop('disabled', false)

    maximumReached: ->
      @options.maximum && (@files.length + @handled_files.length) >= @options.maximum

    addFilesContainer: ->
      if @options.files_container_selector? and $(@options.files_container_selector).length > 0
        @$filesContainer = $(@options.files_container_selector)
      else
        @$filesContainer = $('<div class="attachinary_container">')
        @$input.after @$filesContainer

    redraw: ->
      @$filesContainer.empty()

      _all_files = @handled_files.concat(@files)
      if(_all_files).length > 0
        @$filesContainer.append @makeHiddenField(JSON.stringify(@files))
        @$filesContainer.append @config.render(_all_files, @displayOptions)
        @$filesContainer.find('[data-remove]').on 'click', (event) =>
          event.preventDefault()
          @removeFile $(event.target).data('remove')

        @$filesContainer.show()
      else
        @$filesContainer.append @makeHiddenField(null)
        @$filesContainer.hide()

    makeHiddenField: (value) ->
      $input = $('<input type="hidden">')
      $input.attr 'name', @options.field_name
      $input.val value
      $input

  # JavaScript templating by John Resig's
  $.attachinary.Templating =
    settings:
      start:        '<%'
      end:          '%>'
      interpolate:  /<%=(.+?)%>/g

    escapeRegExp: (string) ->
      string.replace(/([.*+?^${}()|[\]\/\\])/g, '\\$1')

    template: (str, data) ->
      c = @settings
      endMatch = new RegExp("'(?=[^"+c.end.substr(0, 1)+"]*"+@escapeRegExp(c.end)+")","g")
      fn = new Function 'obj',
        'var p=[],print=function(){p.push.apply(p,arguments);};' +
          'with(obj||{}){p.push(\'' +
          str.replace(/\r/g, '\\r')
          .replace(/\n/g, '\\n')
          .replace(/\t/g, '\\t')
          .replace(endMatch,"✄")
          .split("'").join("\\'")
          .split("✄").join("'")
          .replace(c.interpolate, "',$1,'")
          .split(c.start).join("');")
          .split(c.end).join("p.push('") +
          "');}return p.join('');"
      if data then fn(data) else fn

)(jQuery)
