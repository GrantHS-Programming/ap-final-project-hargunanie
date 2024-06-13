package com.example.openstatik

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.Button
import androidx.compose.material3.Text
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.core.app.ActivityCompat
import com.example.openstatik.recorder.AndroidAudioPlayer
import com.example.openstatik.recorder.AndroidAudioRecorder
import com.example.openstatik.ui.theme.OpenStatikTheme
import java.io.File

class MainActivity : ComponentActivity() {

    private val recorder by lazy {
        AndroidAudioRecorder(applicationContext)
    }

    private val player by lazy {
        AndroidAudioPlayer(applicationContext)
    }

    private var audioFile: File? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ActivityCompat.requestPermissions(
            this,
            arrayOf(android.Manifest.permission.RECORD_AUDIO),
            0
        )
        setContent {
            OpenStatikTheme {
                Column(
                    modifier = Modifier.fillMaxSize(),
                    verticalArrangement = Arrangement.Center,
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Button(onClick = {
                        File(cacheDir, "audio.mp3").also {
                            recorder.start(it)
                            audioFile = it
                        }
                    }) {
                        Text(text = "start recording")
                    }
                    Button(onClick = { recorder.stop() }) {
                        Text(text = "stop recording")
                    }
                    Button(onClick = { player.playFile(audioFile ?: return@Button) }) {
                        Text(text = "start playing")
                    }
                    Button(onClick = { player.stop() }) {
                        Text(text = "stop playing")
                    }
                    Text("I did stuff on June 13th. This is not a joke")

                }
                //  surface container using the 'background' color from the theme

            }
        }
    }
}
