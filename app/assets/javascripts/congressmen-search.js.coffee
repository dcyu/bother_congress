$ ->
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
      <a class="overlay" href="#">
        <h4 class="t-arvo t-white">Contact</h4>
      </a>
    </div>
  """)

  $('input#q').keyup ->
    if $("input#q").val().length > 1
      $.ajax
        type: "GET"
        url: '/congressmen/search'
        data: $("#qform").serialize()
        success: (data) ->
          new_content = $("<div></div>").addClass("congressmen").append((template(json) for json in data).join(" "))
          $(".congressmen").replaceWith(new_content)
