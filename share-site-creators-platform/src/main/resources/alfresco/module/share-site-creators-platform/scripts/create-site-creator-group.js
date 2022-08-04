const GROUP_PREFIX = "GROUP_";

const GROUP_SITE_CREATORS_ID = "SITE_CREATORS";

const GROUP_SITE_CREATORS_LABEL = "SITE_CREATORS";


function getOrCreateGroup(groupId, groupLabel) {
  var currentGroup = people.getGroup(GROUP_PREFIX + groupId);
  if (!currentGroup) {
    currentGroup = people.createGroup(groupId);
    currentGroup.properties["cm:authorityDisplayName"] = groupLabel;
    currentGroup.save();
    logger.info("[share-site-creator] Groupe " + groupId + " créé");
  }
  return currentGroup;
}

function main() {
  try {
    // Création du groupe "site creator" si celui-ci n'existe pas
    var groupSiteCreators = getOrCreateGroup(GROUP_SITE_CREATORS_ID, GROUP_SITE_CREATORS_LABEL);
  } catch (e) {
    logger.error("[share-site-creator] Erreur durant l'execution du patch : " + e.message);
  }
}

main();