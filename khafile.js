var project = new Project('Lines');

project.addSources('Sources');
project.addLibrary('Micro');

project.targetOptions.android_native.screenOrientation = 'landscape';
project.targetOptions.android.screenOrientation = 'landscape';

return project;