package boaventura.com.devel.br.flutteraudioquery;

public interface PermissionManager {

    boolean isPermissionGranted(String permissionName);
    void askForPermission(String permissions, int requestCode);
}
