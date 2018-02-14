# module ElemOrGroupSamples
#   extend ActiveSupport::Concern
#
#   # Estos metodos van inicialmente en  Humidity, Damage y Caliber, pero deberian
#   # ser igual para todos, estandar (Ir en AllSamplesMethods ). No se hace
#   # inicialmente asi, para minimizar trabajo y probabilidades de error
#
#   # included do
#   # end
#
#   ### Metodos para hacer que sea posible trabajar con elem y group ####
#   #####################################################################
#   def product_type
#     return self.element.product_type if self.element
#     return self.group.product_type if self.group
#     nil
#   end
#   # Get all Samples of a process
#   def self.process(process)
#     class_sym = self.class.name.to_sym
#     getter_name = {
#       CaliberSample: "cal_samples",
#       DamageSample: "dam_samples",
#       HumiditySample: "hum_samples"}
#     group_or_elem = Util.group_or_elem(process)
#     # si process = recepcion_seco, lo convierte a secado
#     product_type = ProductType.find_by_process(process)
#     product_type.send(getter_name[class_sym], group_or_elem)
#     # Example: product_type.cal_samples(group_or_elem)
#   end
#
#
#   # module ClassMethods
#   # end
#
# end
