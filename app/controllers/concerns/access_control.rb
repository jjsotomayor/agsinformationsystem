module AccessControl
# Modulo para controlar acceso a los controladores
  private

  # NOTE: Nunca leer informacion de las COOKIES, peligroso

  # Revisa los permisos para controladores de samples o redirige
  ####################################################
  ######### Chequea los permisos de samples ##########
  def check_permissions_samples_controller_or_redirect
    #TODO: Mejorar, esto por defecto deberia bloquear, como todos los demas.
    if action_name.in?(["show", "index"]) and !can_see_samples?
      redirect_to root_path, alert: not_allowed
    elsif !can_modify_samples?
      redirect_to root_path, alert: not_allowed
    end
  end

  ####################################################
  ############## Access Samples ######################

  def can_see_samples?
    return true if get_role_or_nil
    false
  end

  def can_modify_samples?
    role = get_role_or_nil
    return true if role.in?(['admin', "UserControl", 'jefe_control_calidad'])
    false
  end

  ####################################################
  ############## Access Element ######################
  def can_create_update_element?
    role = get_role_or_nil
    return true if role.in?(['admin', 'jefe_control_calidad'])
    false
  end

  ####################################################
  ################# Access IP's ######################
  def can_access_all_ip?
    role = get_role_or_nil
    return true if role.in?(['admin'])
    false
  end

  ####################################################
  ################ Access Report #####################
  def can_access_all_report?
    role = get_role_or_nil
    return true if role.in?(['admin', 'jefe_planta', 'jefe_control_calidad', 'jefe_bodega'])
    false
  end

  ####################################################
  ############# Access UserControles #################
  def can_manage_user_controls?
    role = get_role_or_nil
    return true if role.in?(['admin', 'jefe_control_calidad'])
    false
  end

  ####################################################
  ################# Access Users #####################
  def can_manage_users?
    role = get_role_or_nil
    return true if role.in?(['admin'])
    false
  end

  ####################################################
  ################### Mensajes #######################

  def not_allowed
    'No tienes autorización para realizar la acción'
  end

  def not_implemented
    'El sitio buscado no está implementado'
  end


end
