$(document).ready(function(){
  $(".new-player").click(function() {
    $(".new-player-form").slideToggle("fast");
  });
  $(".new-penalty").click(function() {
    $(".new-penalty-form").slideToggle("fast");
  });
  $(".new-hole").click(function() {
    $(".new-hole-form").slideToggle("fast");
  });
  $(".new-score").click(function() {
    $(this).next(".new-score-form").slideToggle("fast");
  });
  
  // $myDiv.click(function(){
  //   $.post('myUrl', function(data){
  //     $myHand.html(data);
  //   });
  // })
  
});




// respond_to do |format|
//   format.html {
//     if request.xhr?
//       render :partial => 'my_hand', :locals => {}
//     end
//   }
// end