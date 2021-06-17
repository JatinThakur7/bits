package com.seven.bits;

import com.google.firebase.FirebaseApp;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingBackgroundService;

//https://stackoverflow.com/questions/64197752/bad-state-insecure-http-is-not-allowed-by-platform
public class Application extends FlutterApplication implements PluginRegistrantCallback {

    @Override
    public void registerWith(PluginRegistry registry) {

        //GeneratedPluginRegistrant.registerWith(registry);
        PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    }

    @Override
    public void onCreate() {
        super.onCreate();
        FirebaseApp.initializeApp(this);
        FlutterFirebaseMessagingBackgroundService.setPluginRegistrant(this);
    }

}
