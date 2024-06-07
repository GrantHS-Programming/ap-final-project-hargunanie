package com.example.openstatik.recorder

import java.io.File

interface AudioRecorder {
    fun start(outputFile: File)
    fun stop()
}