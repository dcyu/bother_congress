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
    if $("input#q").val().length > 2
      $.ajax
        type: "GET"
        url: '/congressmen/search'
        data: $("#qform").serialize()
        success: (data) ->
          console.log(data)
          $(".congressmen").html((template(json) for json in data).join(" "))
