
The use of Routing Intent in a Virtual Hub requires the hub be made 'secure' by associating a firewall (to serve as the next-hop for the routing policy).

The 'azureFirewall' parameter in Microsoft.Network/virtualHubs is *read-only*; in order to properly deploy a Virtual Hub using Routing Intent, the hub's Resource ID must first be passed to the firewall in order for it to be properly associated. In order for this resource to work properly, the resources need to be created in the following order:

- **Virtual Hub**: Suggest minimal hub configuration; name/location/addressPrefix/virtualWan.id
- **Firewall**: Including Virtual Hub Resource ID in the firewall configuration
- **Virtual Hub**: Including all remaining parameters + Routing Intent

