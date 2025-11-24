<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Usuario;

class UsuarioController extends Controller
{
    public function index() {
        $usuarios = Usuario::all(); // Devuelve todo lo de la tabla
        return response()->json($usuarios);
    }
}
