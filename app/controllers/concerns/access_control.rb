module AccessControl
# Modulo para controlar acceso a los controladores
  private

  # NOTE: Nunca leer informacion de las COOKIES, peligroso

  # Revisa los permisos para controladores de samples o redirige
  ####################################################
  ######### Chequea los permisos de samples ##########
  def check_permissions_samples_controller_or_redirect
    #TODO: Mejorar, esto por defecto deberia bloquear, como todos los demas.
    # if action_name.in?(["show", "index"]) and !can_see_samples?
    #   redirect_to root_path, alert: not_allowed
    # elsif !can_modify_samples?
    #   redirect_to root_path, alert: not_allowed
    # end
    if action_name.in?(["show", "index"]) and can_see_samples?
      return
    elsif can_modify_samples? # Podria especificar cuales!
      return
    end
    redirect_to root_path, alert: not_allowed
  end

  ####################################################
  ############## Access Samples ######################

  # Recibe arreglo con lista de roles autorizados
  def role_belongs_to?(admitted)
    role = get_role_or_nil
    return true if role.in?(admitted)
    false
  end

  def can_see_samples?
    get_role_or_nil ? true : false
  end

  def can_modify_samples?
    role_belongs_to?(['admin', "UserControl", 'jefe_calidad'])
  end

  ####################################################
  ############## Access Element ######################
  def can_create_update_element?
    role_belongs_to?(['admin', 'jefe_calidad'])
  end

  def can_destroy_element?
    role_belongs_to?(['admin', 'jefe_calidad'])
  end

  ####################################################
  ################# Access IP's ######################
  def can_access_all_ip?
    role_belongs_to?(['admin'])
  end

  ####################################################
  ################ Access Report #####################
  def can_access_all_report?
    role_belongs_to?(['admin', 'jefe_calidad', 'jefe_bodega', 'lector', 'op_bodega'])
  end

  # NOTE operador bodega no puede descargar
  def can_download?
    role_belongs_to?(['admin', 'jefe_calidad', 'jefe_bodega', 'lector'])
  end

  ####################################################
  ############# Access UserControles #################
  def can_manage_user_controls?
    role_belongs_to?(['admin', 'jefe_calidad'])
  end

  ####################################################
  ################# Access Users #####################
  def can_manage_users?
    role_belongs_to?(['admin'])
  end

  ####################################################
  ################# Access Bodega #####################
  def can_move_element?
    role_belongs_to?(['admin', 'jefe_bodega', 'op_bodega'])
  end

  ####################################################
  ############ Access Elements_group ################
  ####################################################
  def can_see_groups?
    role_belongs_to?(['admin', 'jefe_calidad', 'UserControl', 'lector'])
  end

  def can_create_group?
    role = get_role_or_nil
    if role == 'UserControl' and logged_user.has_access_to?("recepcion_seco")
      return true
    elsif role.in?(['admin', 'jefe_calidad'])
      return true
    end
    false
  end

  def can_update_group?(group)
    role = get_role_or_nil
    if role == 'UserControl' and logged_user.has_access_to?("recepcion_seco") and Time.now - group.created_at < 2*3600# 1 horas
      return true
    elsif role.in?(['admin', 'jefe_calidad'])
      return true
    end
    false
  end

  def can_add_remove_element_of_group?(group)
    role = get_role_or_nil
    if role == 'UserControl' and logged_user.has_access_to?("recepcion_seco") and Time.now - group.created_at < 2*3600# 1 horas
      return true
    elsif role.in?(['admin', 'jefe_calidad'])
      return true
    end
    false
  end

  def can_destroy_group?(group)
    role = get_role_or_nil
    if role.in?(['UserControl']) and logged_user.has_access_to?("recepcion_seco") and Time.now - group.created_at < 2*3600# 1 horas
      return true
    elsif role.in?(['admin', 'jefe_calidad'])
      return true
    end
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

  ####################################################
  ######### Inside controller accesses ###############
  ###### Accesos una vez dentro del controlador ######
  ####################################################

  # Retorna can_destroy?, message. Message contiene el error
  def can_destroy_this_element?(logged_user, element)
    # Asume que ya se chequeo que usuario esta logueado
    if logged_user.role.name.in?(["jefe_calidad", "admin"])
      if element.has_entered_warehouse?
        message = {type: :error,
                  title: "No puedes eliminar producto que haya ingresado a bodega"}
        return false, message
      elsif @element.samples_count > 0
        message = {type: :error,
                  title: "Debes eliminar todas las muestras de un producto antes de poder eliminarlo"}
        return false, message
      end
      return true, {type: :success, title: "Producto eliminado exitosamente"}
    end

    return false, {type: :error, title: not_allowed}# No se encontró al usuario

  end

end
