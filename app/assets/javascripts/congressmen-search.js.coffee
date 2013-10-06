refresh_congressmen_view = ->
  template = Handlebars.compile("""
    <div id="congressman-{{id}}" class="congressman">
      <img src="{{picture_url}}"></img>
      <strong>
        {{title}}. {{firstname}} {{lastname}}
      </strong>
      <label>
        <b>
          {{party}} - {{state}}
        </b>
      <a class="overlay {{#if selected}}selected{{else}}unselected{{/if}}" href="#" data-id="{{id}}">
        <h4 class="t-arvo t-white">{{#if selected}}&#10003;{{else}}Select{{/if}}</h4>
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
  if $("#selected").children().size() < 3
    $.ajax
      type: "POST",
      url: '/congressmen/add_recipient',
      data: {id: $(this).data('id')},
      success: (data) =>
        $(this).removeClass('unselected').addClass('selected').find('h4').html("&#10003;")
        $("#selected").html(("<span class='selected-name'>#{congressman.fullname}<div class='close-link' data-id='#{congressman.id}'>&times;</div></span>" for congressman in data).join(""))
  else
    $("#error_message").show()

remove_recipient = (e) ->
  $.ajax
    type: "POST",
    url: '/congressmen/remove_recipient',
    data: {id: $(this).data('id')},
    success: (data) =>
      $("#congressman-#{$(this).data('id')} a").removeClass('selected').addClass('unselected').find('h4').html("Select")
      $("#selected").html(("<span class='selected-name'>#{congressman.fullname}<div class='close-link' data-id='#{congressman.id}'>&times;</div></span>" for congressman in data).join(""))

show_search_filters = (e) ->
  $("#search-filters").show()

  $("#state-select, #legislator-type-select, #political-party-select").chosen(
    disable_search_threshold: 5
    allow_single_deselect: true
  )

  $("#show-search-filters-link").hide()
  $("#hide-search-filters-link").show()

hide_search_filters = (e) ->
  $("#search-filters").hide()
  $("#show-search-filters-link").show()
  $("#hide-search-filters-link").hide()

$ ->
  timer = null
  $('input#q').keyup ->
    if timer
      clearTimeout(timer)

    timer = setTimeout(refresh_congressmen_view, 250)

  $("body").delegate ".overlay.unselected", "click", add_recipient
  $("body").delegate ".overlay.selected", "click", remove_recipient
  $("body").delegate ".close-link", "click", remove_recipient
  $("body").delegate "#show-search-filters-link", "click", show_search_filters
  $("body").delegate "#hide-search-filters-link", "click", hide_search_filters
  $("body").delegate "#state-select, #legislator-type-select, #political-party-select", "change", refresh_congressmen_view
