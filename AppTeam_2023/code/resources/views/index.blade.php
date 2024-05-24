@extends('_layouts.app')
@section('title')
Home
@endsection


@section('content')
<!DOCTYPE html>
<html>
<head>
<style>
.img {
        display: block;
        margin-left: auto;
        margin-right: auto;
        width: 50%;
        }

.center {
        text-align: center;
        }
</style>
</head>

<body>
<div class="center">
    <h1>VESNA</h1>
    <p>{{__('index.caption')}}</p>
</div>
        

<img src="/images/vesna.jpg" alt="Greenhouse" class="img">
</body>
</html>
@endsection('content')