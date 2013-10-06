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
      <a class="overlay" href="#" data-id="{{id}}">
        <h4 class="t-arvo t-white">Contact</h4>
      </a>
    </div>
  """)

  $.ajax
    type: "GET"
    url: '/congressmen/search'
    data: $("#qform").serialize()
    success: (data) ->
      new_content = $("<div></div>").addClass("congressmen").append((template(json) for json in data).join(" "))
      $(".congressmen").replaceWith(new_content)


$ ->
  timer = null
  $('input#q').keyup ->
    if timer
      clearTimeout(timer)

    timer = setTimeout(refresh_congressmen_view, 250)

  $("body").delegate ".overlay.unselected", "click", (e) ->
    $.ajax
      type: "POST",
      url: '/congressmen/add_recipient',
      data: {id: $(this).data('id')},
      success: (data) =>
        $(this).removeClass('unselected').addClass('selected').find('h4').html("&#10003;")
        $(this).find('h4').attr('style', 'font-size:100px;')

  $("body").delegate ".overlay.selected", "click", (e) ->
    $.ajax
      type: "POST",
      url: '/congressmen/remove_recipient',
      data: {id: $(this).data('id')},
      success: (data) =>
        $(this).removeClass('selected').addClass('unselected').find('h4').html("Select")
        $(this).find('h4').attr('style', 'font-size:50px;')