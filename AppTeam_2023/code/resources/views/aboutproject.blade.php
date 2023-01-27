@extends('_layouts.app')

@section('content')
<!DOCTYPE html>
<html>
<head>
<title>Project VESNA</title>
<style>p{text-align: justify;}</style>
</head>
<body>

<h1 class="h1 mb-0 text-gray-800">{{ __('aboutproject.about_vesna') }}</h1>
   <p>{{ __('aboutproject.about_vesna_text') }}</p>
   <p> {{ __('aboutproject.about_vesna_text_two') }}</p> 

   <h4><b>Core Team</b></h4>
   <p>{{ __('aboutproject.core_team') }}</p>

   <h4><b>Smart Team</b></h4>
   <p>{{ __('aboutproject.smart_team') }}</p>

   <h4><b>App Team</b></h4>
   <p>{{ __('aboutproject.app_team') }} </p>


<p> {{ __('aboutproject.info') }} <a href="https://vesna.uiam.sk/">{{ __('aboutproject.off_page') }}</a>. </p>

</body>
</html>
@endsection('content')