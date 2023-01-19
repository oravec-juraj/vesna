<div class="row justify-content-center">
    <div class="col-10" >    
        @if (session()->has('success'))
            <div class="alert alert-success" role="alert" >{!! session()->get('success') !!}</div>
        @endif
        
        @if (session()->has('failure'))
            <div class="alert alert-danger" role="alert">{!! session()->get('failure') !!}</div>
        @endif  
        
        @if ($errors->any())
        <div class="alert alert-danger rounded-0">
            <ul>
                @foreach ($errors->all() as $error)
                <li>{{ $error }}</li>
                @endforeach
            </ul>
        </div>
        @endif
    </div>
</div>