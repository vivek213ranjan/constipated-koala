$(document).on('ready page:load turbolinks:load', function(){
    $('.toggle-min').click(function(event){
    event.preventDefault();
    setup_intl_tel_input();
    $('#app').children('div').toggleClass('nav-min');
    });

    $('#year').on('change', function(){
        var params = {};

        params.year = $(this).val();
        location.search = $.param(params);
    });
});


