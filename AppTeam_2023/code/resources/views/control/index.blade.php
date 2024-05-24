@extends('_layouts.app')

@section('content')

<h1 class="h1 mb-0 text-gray-800">{{ __('control_index.control') }}</h1>
<style>p{text-align: justify;}</style>
<p>
    {{ __('control_index.function') }}
</p>

<p>
{{ __('control_index.intro') }} 
</p>

<h5><b>{{ __('control_index.temp') }}</b></h5>
<p>
{{ __('control_index.temp_text') }}    
</p>

<h5><b>{{ __('control_index.light') }}</b></h5>
<p>
{{ __('control_index.light_text') }} <br/>
{{ __('control_index.light_text_two') }} 
</p>

<h5><b>{{ __('control_index.ventilation') }}</b></h5>
<p>
{{ __('control_index.ventilation_text') }}
</p>

<h5><b>{{ __('control_index.irrigation') }}</b></h5>
<p>
{{ __('control_index.irrigation_text') }}</p>
@endsection('content')