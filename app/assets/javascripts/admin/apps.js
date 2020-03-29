//
//= require bootstrap-file-input

$(document).on( 'ready page:load turbolinks:load', function(){

  bind_flip();

  // $('form .input-group-btn .file-input-wrapper input[type="file"]').on('change', function(){
  //   if( this.files && this.files[0] ){
  //     $('form .input-group input#output').val(this.files[0].name);
  //   }
  // });



  // [DELETE] checkout_product
  $('#products button.destroy').on('click', function(){
    var id = $(this).closest('tr').attr('data-id');
    var token = encodeURIComponent($(this).closest('.page').attr('data-authenticity-token'));
    var row = $(this).closest('tr');

    if( !confirm($(row).find('a').html() + ' verwijderen?') )
      return;

    $.ajax({
      url: '/apps/products',
      type: 'DELETE',
      data: {
        id: id,
        authenticity_token: token
      }
    }).done(function(){
      toastr.warning($(row).find('a').html() + ' verwijderd');
      $(row).remove();
    }).fail(function(error){
      toastr.error(error.statusText, error.status);
    });
  });


  $('.date-input input').on('change', function(){
    var params = {};

    params.date = $(this).val();
    location.search = $.param(params);
  });

  $('form').on('submit', function(){
    $( this ).find('button[type="submit"].wait').addClass('disabled');
  });

});

function bind_flip(){
  //Reset all event handlers
  $('#products button').off('click');

  $('#products').find('button.activate').on('click', product.activate);
  $('#products').find('button.deactivate').on('click', product.deactivate);;
}

var product = {
  deactivate : function(){
    var row = $(this).closest('tr');

    $.ajax({
      url: '/apps/products/' + row.attr( 'data-id' ) + '/flip',
      type: 'PATCH',
      data: {
        checkout_product: {
          active: false
        }

      }
    }).done(function(){
      toastr.success($(row).find('a').html() + ' is gedeactiveerd');

      $(row)
        .addClass('inactive')
        .find( 'button.deactivate' )
        .empty()
        .removeClass( 'deactivate btn-warning' )
        .addClass( 'activate btn-primary' )
        .append( '<i class="fa fa-fw fa-check"></i> Activeer' );

      //Reset all event handlers
      bind_flip();

    }).fail(function(error){
      toastr.error(error.statusText, error.status);
    });
  },

  activate : function(){
    var row = $(this).closest('tr');

    $.ajax({
      url: '/apps/products/' + row.attr('data-id') + '/flip',
      type: 'PATCH',
      data: {
        checkout_product: {
          active: true
        }
      }
    }).done(function(){
      toastr.success($(row).find('a').html() + ' is geactiveerd');

      $(row)
        .removeClass( 'inactive' )
        .find( 'button.activate' )
        .empty()
        .removeClass( 'activate btn-primary inactive' )
        .addClass( 'deactivate btn-warning' )
        .append( '<i class="fa fa-fw fa-times"></i> Deactiveer' );

        bind_flip();

    }).fail(function(error){
      toastr.error(error.statusText, error.status);
    });
  }
};
