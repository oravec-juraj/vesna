<ul class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion" id="accordionSidebar">

    <!-- Sidebar - Brand -->
    <a class="sidebar-brand d-flex align-items-center justify-content-center" href="index">
        <div class="sidebar-brand-icon rotate-n-15">
            <i class="fas fa-seedling"></i>
        </div>
        <div class="sidebar-brand-text mx-3">VESNA</div>
    </a>

    <!-- Divider -->
    <hr class="sidebar-divider my-0">

    <!-- Nav Item - Dashboard -->
    @auth
    <li class="nav-item active">
        <a class="nav-link collapsed" data-toggle="collapse" data-target="#collapsePagestoControl" aria-expanded="true" aria-controls="collapsePagestoControl">
            <i class="fas fa-fw fa-tachometer-alt"></i>
            <span>Greenhouse Cotrol</span>
        </a>
        <div id="collapsePagestoControl" class="collapse" aria-labelledby="headingPages" data-parent="#accordionSidebar">
            <div class="bg-white py-2 collapse-inner rounded">
                <a class="collapse-item" href="{{route('control_index')}}"><span>Control of Greenhouse</span></a>
                <h6 class="collapse-header">Control Screens:</h6>
                <a class="collapse-item" href="{{route('control_environment')}}"><span>Environment Monitoring</span></a>
                <a class="collapse-item" href="{{route('control_plant')}}"><span>Choice of Plant</span></a>
                @if(Auth::user()->is_admin)
                <a class="collapse-item" href="{{route('control_advanced')}}"><span>Advanced Control</span></a>
                @endif
            </div>
        </div>
    </li>
    @endauth

    <!-- Nav Item - About Project -->
        <li class="nav-item active">
        <a class="nav-link" href="{{route('aboutproject')}}">
            <i class="fas fa-fw fa-leaf"></i>
            <span>About Project</span></a>
    </li>

    <!-- Nav Item - Statistics -->
    <li class="nav-item active">
        <a class="nav-link" href="{{route('chart')}}">
            <i class="fas fa-fw fa-chart-line"></i>
            <span>Statistics</span></a>
    </li>

    <!-- Nav Item - Livestream -->
    <li class="nav-item active">
    <a class="nav-link" href="{{route('livestream')}}">
        <i class="fas fa-fw fa-video"></i>
        <span>Livestream</span></a>
    </li>
    @auth
        <li class="nav-item active">
        <a class="nav-link collapsed" data-toggle="collapse" data-target="#collapseGallery" aria-expanded="true" aria-controls="collapseGallery">
            <i class="fas fa-fw fa-images"></i>
            <span>Gallery</span>
        </a>
        <div id="collapseGallery" class="collapse" aria-labelledby="headingPages" data-parent="#accordionSidebar">
            <div class="bg-white py-2 collapse-inner rounded">
                <a class="collapse-item" href="{{route('gallery')}}"><span>Gallery</span></a>
                <a class="collapse-item" href="{{route('timelapse')}}"><span>Timelapse</span></a>
            </div>
        </div>
    </li>
    @endauth

    <!-- Nav Item - New user registartion -->
    @auth
    @if(Auth::user()->is_admin)
    <li class="nav-item active">
    <a class="nav-link" href="{{route('register')}}">
        <i class="fas fa-fw fa-user"></i>
        <span>Registration</span></a>
    </li>  
    @endif
    @endauth

    <!-- Divider -->
    <hr class="sidebar-divider d-none d-md-block">

    <!-- Sidebar Toggler (Sidebar) -->
    <div class="text-center d-none d-md-inline">
        <button class="rounded-circle border-0" id="sidebarToggle"></button>
    </div>

    

</ul>