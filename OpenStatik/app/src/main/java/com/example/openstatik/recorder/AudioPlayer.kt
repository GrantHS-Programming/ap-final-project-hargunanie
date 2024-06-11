package com.example.openstatik.recorder

import java.io.File

interface AudioPlayer {
    fun playFile(file: File)
    fun stop()
}