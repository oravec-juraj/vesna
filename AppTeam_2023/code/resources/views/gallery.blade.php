@extends('_layouts.app')

@section('content')


<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">Gallery @if(isset($info_month)) {{$info_month}} @endif</h1>
</div>


<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<link  href="https://cdnjs.cloudflare.com/ajax/libs/fotorama/4.6.4/fotorama.css" rel="stylesheet">
<script src="vendor/fotorama/fotorama.js"></script>
<script>
  fotoramaDefaults = {
    width: 920,
    maxwidth: '100%',
    ratio: 16/9,
    allowfullscreen: true,
    nav: 'thumbs'
  }
</script>

<div class="container">
<!-- Add images to <div class="fotorama"></div> -->
<div class="fotorama" 
     data-clicktransition="crossfade" data-loop="true" data-nav="thumbs" data-stopautoplayontouch="false" >
  @foreach($urls as $name)
                <img src="{{$name}}">
    @endforeach
</div>
<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card" style="margin-top:20px">
            <div class="card-body">
    {!! Form::open(['route' => 'submit']) !!}
    <div class="d-flex justify-content">
    <div style="width:100%; padding-right: 10px;">
      {{ Form::select('month', ['' => 'Select month'] + $months, '', ['class' => 'form-control']) }}
    </div>
    <div style="width:100%">
      {{ Form::select('year', ['' => 'Select year'] + range($start_year, $end_year), '', ['class' => 'form-control']) }}
    </div>
    </div>
    <div style="margin-top:10px">
    {{ Form::submit('Submit', ['class' => 'btn btn-primary']) }}
    {!! Form::close() !!}
    </div>
</div>
</div>
</div>
</div>
</div>
</div>


@endsection('content')