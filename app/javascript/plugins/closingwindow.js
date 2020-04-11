const closingWindow = () => {
$(window).bind('beforeunload', function(){
  return 'Are you sure you want to leave?';
});

$(document).on("submit", "form", function(event){
          // disable warning
          $(window).off('beforeunload');
      });

$(window).unload(function(){
  alert('Bye.');
});


};

export { closingWindow } ;
