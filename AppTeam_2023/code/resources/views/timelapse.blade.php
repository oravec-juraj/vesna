@extends('_layouts.app')

@section('content')
<!-- Page Heading -->
<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">{{__('timelapse.caption')}}</h1>
</div>


<BODY  BGCOLOR="#000000">
<div class="container">
<img style="width:920px;" name="foto">
<SCRIPT LANGUAGE="JavaScript">

var Pic = <?php echo json_encode($new_facets); ?>;
var t;
var j = 0;
var p = Pic.length;
var preLoad = new Array();
for (i = 0; i < p; i++) {
    preLoad[i] = new Image();
    preLoad[i].src = "https://rtsp-screenshots.cloud.uiam.sk/cam1/"+Pic[i]+"jpg";
}
index = 6; 
function update(){
if (preLoad[index]!= null){
    document.images['foto'].src = preLoad[index].src;
    index++;
    setTimeout(update, 100);
}

}
update();

</script>
</div>
</BODY>

@endsection('content')
