@extends('_layouts.app')

@section('content')
<!-- Page Heading -->
<div class="d-sm-flex align-items-center justify-content-between mb-4">
    <h1 class="h3 mb-0 text-gray-800">Statistics</h1>
</div>

<div class="container-fluid">
    @foreach($keys as $name)    {{-- builds content 'table' --}}
        @if($loop->odd)
            <div class="row border border-dark d-flex align-items-center">
                <div class="col border chart-container">
                    <canvas id="{{$name}}"></canvas>
                </div>
        @else
                <div class="col border chart-container">
                    <canvas id="{{$name}}"></canvas>
                </div>
                <div class="col-2 text-center">
                    <div class="rounded-circle">Current {{__('charts.'.Str::beforeLast($name, '_').'_name')}} value: <div id="{{Str::beforeLast($name, '_')}}"></div></div>
                </div>
            </div>
        @endif
    @endforeach

</div>
@endsection('content')

@section('scripts')
<script src="{{asset('vendor/chart.js/Chart.min.js')}}"></script>
<script src="{{asset('vendor/chart.js/Chart.js')}}"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-adapter-date-fns/dist/chartjs-adapter-date-fns.bundle.min.js"></script>


<script>
    var tempdata = {{Js::from($data)}}; 
    var vec = JSON.parse(tempdata);     {{-- loads incoming data into js array --}}
</script>

@foreach($keys as $row)     {{-- attaches data to corresponding charts --}}
<script>
    
    var ctx = document.getElementById("{{$row}}")

    var myChart = new Chart(ctx, {
        type: 'line',
        data: {
            //labels: [],
            datasets: [{
                label: "{{__('charts.'.$row)}}",    {{-- uses lang files for more robust looping --}}
                data: vec.{{$row}},
                borderColor: "{{__('charts.'.Str::beforeLast($row, '_').'_color')}}",
            //borderWidth: 1
        }]
        },
        options: {
            parsing: {
                xAxisKey: 'time',
                yAxisKey: 'value'
            },
            scales: {
                x: {
                    type: 'timeseries',
                }
            },
            elements:{
                point:{
                    borderWidth: 0,
                    radius: 0,
                    backgroundColor: 'rgba(0,0,0,0)'
                }
            },
            resizeDelay: 20,    {{-- to resize charts only after bootstrap resizes divs --}}

        }
    });
</script>
@endforeach

<script>
    assignCurrent = function($key, $value){
        var elem = document.getElementById($key);   {{-- attaches current data to a corresponding element --}}
        elem.textContent = $value;
    }

    updateCurrent = function() {        {{-- gets current data asynchronously through controller --}}
        $.ajax({
            url: "{{ route('current_data') }}",
            type: 'GET',
            dataType: 'json',
            headers: {
                'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
            },
            success: function(data) {
                console.log('success');
                for (const [key, value] of Object.entries(data)) {
                    assignCurrent(key, value);
                };
            },
            error: function(data){
                console.log('error');
            }
        });
    }
    
    updateCurrent();
    setInterval(() => {
        updateCurrent();
    }, 10000);      {{-- period between updates in ms --}}
</script>

@endsection