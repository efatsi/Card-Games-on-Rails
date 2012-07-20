$(document).ready(function(){
  $(".game-buttons").find(".play-one-card").click(function(data) {
    // $(".my-hand").slideToggle("fast");
    var $hand = $(".my-hand");
    ($hand).text("okay...");
  });
});



// $myDiv.click(function(){
//   $.post('myUrl', function(data){
//     $myHand.html(data);
//   });
// })

// respond_to do |format|
//   format.html {
//     if request.xhr?
//       render :partial => 'my_hand', :locals => {}
//     end
//   }
// end