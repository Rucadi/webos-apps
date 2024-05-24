{dockerTools, runCommand, undocker}:
{   imageName, 
    imageDigest,
    sha256,
}:
let 
in
runCommand ''get-image'' {}
''
    ${undocker}/bin/undocker ${dockerTools.pullImage 
    {
        imageName = imageName;  
        imageDigest = imageDigest;
        sha256 = sha256;
    }} $out
''