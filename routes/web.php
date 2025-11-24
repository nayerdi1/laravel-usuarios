<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;

use App\Models\Usuario;

Route::get('/', function () {
    return view('welcome');
});



/*Route::get('/probar-usuarios', function () {
    try {
        return Usuario::all(); 
    } catch (\Exception $e) {
        return $e->getMessage();
    }
});*/

Route::get('/usuarios', [App\Http\Controllers\UsuarioController::class, 'index']);