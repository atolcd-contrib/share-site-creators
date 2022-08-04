package com.atolcd.site.creator.repo.bootstrap;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.alfresco.repo.module.AbstractModuleComponent;
import org.alfresco.repo.security.authentication.AuthenticationUtil;
import org.alfresco.service.cmr.repository.NodeRef;
import org.alfresco.service.cmr.repository.NodeService;
import org.alfresco.service.cmr.repository.ScriptService;
import org.alfresco.service.cmr.repository.StoreRef;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.util.Assert;

public class ScriptExecuter extends AbstractModuleComponent implements InitializingBean, AuthenticationUtil.RunAsWork<Object> {

  private static final Log logger = LogFactory.getLog(ScriptExecuter.class);

  private NodeService      nodeService;
  private ScriptService    scriptService;
  private List<String>     scripts;

  public void setNodeService(NodeService nodeService) {
    this.nodeService = nodeService;
  }

  public void setScriptService(ScriptService scriptService) {
    this.scriptService = scriptService;
  }

  public void setScripts(List<String> scripts) {
    this.scripts = scripts;
  }

  public void afterPropertiesSet() throws Exception {
    Assert.notNull(nodeService, "There must be a node service");
    Assert.notNull(scriptService, "There must be a script service");
    Assert.notNull(scripts, "There must be a script list");
  }

  @Override
  protected void executeInternal() throws Throwable {
    AuthenticationUtil.runAs(this, AuthenticationUtil.SYSTEM_USER_NAME);
  }

  public Object doWork() throws Exception {
    NodeRef rootRef = nodeService.getRootNode(StoreRef.STORE_REF_WORKSPACE_SPACESSTORE);
    Map<String, Object> model = new HashMap<>(1);
    model.put("roothome", rootRef);
    for (String script : scripts) {
      logger.info("Executing script: " + script);
      scriptService.executeScript(script, model);
    }
    return null;
  }
}
