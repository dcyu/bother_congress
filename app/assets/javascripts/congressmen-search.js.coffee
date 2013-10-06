refresh_congressmen_view = ->
  template = Handlebars.compile("""
    <div class="congressman">
      <img src="{{picture_url}}"></img>
      <strong>
        {{title}}. {{firstname}} {{lastname}}
      </strong>
      <label>
        <b>
          {{party}} - {{state}}
        </b>
      <a class="overlay {{#if selected}}selected{{else}}unselected{{/if}}" href="#" data-id="{{id}}">
        <h4 class="t-arvo t-white">{{#if selected}}&#10003;{{else}}Contact{{/if}}</h4>
      </a>
    </div>
  """)

  $.ajax
    type: "GET"
    url: '/congressmen/search'
    data: $("#qform").serialize()
    success: (data, status) ->
      if data.status == 'nochange'
        return
      else
        new_content = $("<div></div>").addClass("congressmen").append((template(json) for json in data).join(" "))
        $(".congressmen").replaceWith(new_content)

add_recipient = (e) ->
  $.ajax
    type: "POST",
    url: '/congressmen/add_recipient',
    data: {id: $(this).data('id')},
    success: (data) =>
      $(this).removeClass('unselected').addClass('selected').find('h4').html("&#10003;")
      $("#selected").html(("<span>#{congressman.fullname}</span>" for congressman in data).join(""))

remove_recipient = (e) ->
  $.ajax
    type: "POST",
    url: '/congressmen/remove_recipient',
    data: {id: $(this).data('id')},
    success: (data) =>
      $(this).removeClass('selected').addClass('unselected').find('h4').html("Select")
      $("#selected").html(("<span>#{congressman.fullname}</span>" for congressman in data).join(""))

$ ->
  timer = null
  $('input#q').keyup ->
    if timer
      clearTimeout(timer)

    timer = setTimeout(refresh_congressmen_view, 250)

  $("body").delegate ".overlay.unselected", "click", add_recipient
  $("body").delegate ".overlay.selected", "click", remove_recipient
